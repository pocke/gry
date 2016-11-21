module Gry
  class Analyzer
    # @param cops [Array<String>] cop names. e.g.) ['Style/EmptyElse']
    def initialize(cops)
      @cops = cops
    end

    def analyze
      configs = @cops.map{|cop_name| cop_configs(cop_name)}
      max = configs.max{|a, b| a.size <=> b.size}.size
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
        setting = set_count.sort_by{|pair| pair[1]}.first[0]
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

      rubocop_args.each do |arg|
        cops, setting = *arg
        setting.each do |cop_name, s|
          res[cop_name] ||= {}
          res[cop_name][s] ||= 0
        end

        runner = RubocopRunner.new(cops, setting)
        result = runner.run

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
      # TODO: implement
      case cop_name
      when 'Style/DotPosition'
        [
          {
            'Style/DotPosition' => {
              'EnforcedStyle' => 'leading'
            }
          },
          {
            'Style/DotPosition' => {
              'EnforcedStyle' => 'trailing'
            }
          },
        ]
      when 'Style/ClassAndModuleChildren'
        [
          {
            'Style/ClassAndModuleChildren' => {
              'EnforcedStyle' => 'nested'
            }
          },
          {
            'Style/ClassAndModuleChildren' => {
              'EnforcedStyle' => 'compact'
            }
          },
        ]
      when 'Style/IndentArray'
        [
          {
            'Style/IndentArray' => {
              'EnforcedStyle' => 'special_inside_parentheses'
            }
          },
          {
            'Style/IndentArray' => {
              'EnforcedStyle' => 'consistent'
            }
          },
          {
            'Style/IndentArray' => {
              'EnforcedStyle' => 'align_brackets'
            }
          },
        ]
      else
        raise 'not implemented!'
      end
    end
  end
end
