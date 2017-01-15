module Gry
  module Formatter
    # @param gry_result [Array<Law>]
    # @return [String] a yaml string
    def self.format(laws)
      confs = laws.map do |law|
        to_comment(law.bill) +
          to_yaml({law.name => law.letter})
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
        "# #{x} => #{count} #{offenses(count)}\n"
      end.join
    end

    def self.offenses(count)
      if count > 1
        'offenses'
      else
        'offense'
      end
    end
  end
end
