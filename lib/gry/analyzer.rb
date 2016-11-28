module Gry
  class Analyzer
    # @param cops [Array<String>] cop names. e.g.) ['Style/EmptyElse']
    def initialize(cops)
      @cops = cops
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
        cops = @cops[0...compacted.size]

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
        Concurrent::Future.execute do
          runner.run
        end
      end

      futures.each.with_index do |future, idx|
        result = future.value
        raise future.reason if future.rejected?
        setting = rubocop_args[idx][1]

        result['files'].each do |f|
          f['offenses'].each do |offense|
            cop_name = offense['cop_name']
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
      supporteds = cop_config['SupportedStyles']
      return unless supporteds

      supporteds.map do |style|
        {
          cop_name => {
            'EnforcedStyle' => style
          }
        }
      end
    end
  end
end
