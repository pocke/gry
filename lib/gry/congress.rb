module Gry
  class Congress
    def initialize(max_count:, min_difference:)
      @max_count = max_count
      @min_difference = min_difference
    end

    # @param name [String] cop name
    # @param bill [Hash{Hash => Integer}] rubocop results
    #   {
    #     {config1} => 20,
    #     {config2} =>  0,
    #     {config3} => 10,
    #   }
    # @return [Law]
    def discuss(name, bill)
      # [[conf, count], ...]
      sorted = bill.sort_by{|_conf, count| count}
      min_count = sorted.first.last
      return nil if min_count > @max_count

      second_count = sorted[1].last
      return nil if second_count - min_count < @min_difference

      letter = sorted.first.first
      Law.new(name, bill, letter)
    end
  end
end
