module Gry
  module Formatter
    # @param gry_result [Hash]
    #   {'Style/DotPosition' => { {conf} => count}}
    # @return [String] a yaml string
    def self.format(gry_result)
      confs = gry_result.map do |cop_name, set_count|
        setting = Strategy.results_to_config(set_count)
        next unless setting
        to_comment(set_count) + to_yaml({cop_name => setting})
      end.compact

      to_yaml(RubocopAdapter.config_base) +
        "\n" +
        confs.join("\n")
    end

    private_class_method

    def self.to_yaml(hash)
      YAML.dump(hash)[4..-1]
    end

    def self.to_comment(set_count)
      set_count.map do |setting, count|
        x = setting
          .reject{|key, _| key == 'Enabled'}
          .map{|key, value| "#{key}: #{value}"}
          .join(', ')
        "# #{x} => #{count}\n"
      end.join
    end
  end
end
