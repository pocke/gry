module Gry
  class Formatter
    def initialize(display_disabled_cops:)
      @display_disabled_cops = display_disabled_cops
    end

    # @param gry_result [Array<Law>]
    # @return [String] a yaml string
    def format(laws)
      confs = laws.map do |law|
        if law.letter
          letter = {law.name => law.letter}
        else
          if @display_disabled_cops
            letter = {law.name => {'Enabled' => false}}
          else
            next
          end
        end
        comment = RubocopAdapter.metrics_cop?(law.name) ?
          '' :
          to_comment(law.bill)
        yaml = to_yaml(letter)
        comment + yaml
      end.compact

      to_yaml(RubocopAdapter.config_base) +
        "\n" +
        confs.join("\n")
    end


    private

    def to_yaml(hash)
      YAML.dump(hash)[4..-1]
    end

    def to_comment(set_count)
      set_count.map do |setting, offenses|
        count = offenses.size

        x = setting
          .reject{|key, _| key == 'Enabled'}
          .map{|key, value| "#{key}: #{value}"}
          .join(', ')
        "# #{x} => #{count} #{offenses(count)}\n"
      end.join
    end

    def offenses(count)
      if count > 1
        'offenses'
      else
        'offense'
      end
    end
  end
end
