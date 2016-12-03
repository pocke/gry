module Gry
  class Analyzer
    # @param cops [Array<String>] cop names. e.g.) ['Style/EmptyElse']
    def initialize(cops, parallel:)
      @cops = cops
      @parallel = parallel
    end

    def analyze
      configs = @cops.map{|cop_name| cop_configs(cop_name)}
      max = configs.max_by(&:size).size
      configs.each do |c|
        c.fill(nil, c.size..(max-1))
      end

      rubocop_args = configs.transpose.map do |conf_set|
        compacted = conf_set.compact
        setting = compacted.inject({}) do |a, b|
          a.merge(b)
        end
        cops = setting.keys

        [cops, setting]
      end

      result = execute_rubocop(rubocop_args)
      confs = result.map do |cop_name, set_count|
        setting = Strategy.results_to_config(set_count)
        {cop_name => setting}
      end

      confs.inject({}) do |a, b|
        a.merge(b)
      end
    end


    private

    # @param rubocop_args [Array]
    #   ['Style/DotPosition', {...}, ...]
    # @param result [Hash]
    #   {'Style/DotPosition' => { {conf} => count}}
    def execute_rubocop(rubocop_args)
      res = {}

      futures = rubocop_args.map do |arg|
        cops, setting = *arg
        setting.each do |cop_name, s|
          res[cop_name] ||= {}
          res[cop_name][s] ||= 0
        end

        runner = RubocopRunner.new(cops, setting)
        future = Concurrent::Future.execute do
          runner.run
        end
        wait(future) unless @parallel
        future
      end

      futures.each.with_index do |future, idx|
        wait(future)
        result = future.value
        setting = rubocop_args[idx][1]

        result['files'].each do |f|
          f['offenses'].each do |offense|
            cop_name = offense['cop_name']
            next if cop_name == 'Syntax' # Syntax cop is not configurable.
            res[cop_name][setting[cop_name]] += 1
          end
        end
      end

      res
    end

    # @param cop_name [String]
    # @return [Array<Hash>]
    def cop_configs(cop_name)
      cop_config = RubocopAdapter.default_config[cop_name]

      # e.g. %w[EnforcedHashRocketStyle EnforcedColonStyle EnforcedLastArgumentHashStyle]
      enforced_style_names = RubocopAdapter.configurable_styles(cop_config)

      # e.g. [
      #   %w[key separator table],
      #   %w[key separator table],
      #   w[always_inspect always_ignore ignore_implicit ignore_explicit],
      # ]
      supported_styles = enforced_style_names
        .map{|style_name| RubocopAdapter.to_supported_styles(style_name)}
        .map{|supported_style_name| cop_config[supported_style_name]}

      supported_styles[0].product(*supported_styles[1..-1]).map do |style_values|
        conf = style_values
          .map.with_index{|value, idx| [enforced_style_names[idx], value]}
          .to_h
        conf['Enabled'] = true
        {
          cop_name => conf
        }
      end
    end

    def wait(future)
      future.wait
      raise future.reason if future.rejected?
    end
  end
end
