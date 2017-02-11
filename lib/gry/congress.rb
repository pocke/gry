module Gry
  class Congress
    def initialize(max_count:, min_difference:, metrics_percentile:)
      @max_count = max_count
      @min_difference = min_difference
      @metrics_percentile = metrics_percentile
    end

    # @param name [String] cop name
    # @param bill [Hash{Hash => Array}] rubocop results
    #   {
    #     {config1} => [offenses],
    #     {config2} => [offenses],
    #     {config3} => [offenses],
    #   }
    # @return [Law]
    def discuss(name, bill)
      letter = letter(name, bill)
      Law.new(name, bill, letter)
    end


    private

    def letter(name, bill)
      if RubocopAdapter.metrics_cop?(name)
        letter_for_metrics(bill)
      else
        letter_for_enforced_style(bill)
      end
    end

    def letter_for_metrics(bill)
      raise "bill.size is not 1, got #{bill.size}" unless bill.size == 1
      values = bill
        .values[0]
        .map{|offense| offense['message']}
        .map{|message| message[%r!\[([0-9.]+)/[0-9.]+\]$!, 1]}
        .map(&:to_i)
        .sort

      {
        'Enabled' => true,
        'Max' => percentile(values),
      }
    end

    def letter_for_enforced_style(bill)
      # [[conf, offenses], ...]
      sorted = bill.sort_by{|_conf, offenses| offenses.size}
      min_count = sorted[0].last.size
      return nil if min_count > @max_count

      second_count = sorted[1].last.size
      return nil if second_count - min_count < @min_difference

      sorted.first.first
    end

    # @param values [Array<Numeric>]
    # @return [Numeric]
    def percentile(values)
      size = values.size
      index = size.to_f / 100 * @metrics_percentile - 1
      v1 = values[index.floor]
      v2 = values[index.ceil]

      v1 + (index - index.ceil) * (v2 - v1)
    end
  end
end
