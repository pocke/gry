module Gry
  class Congress
    def initialize(count_limit:)
      @count_limit = count_limit
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
      letter = bill
        .select{|_conf, count| count <= @count_limit }
        .sort_by{|_conf, count| count}
        .first # to get minimum conf and count
        &.first # to get conf

      return nil unless letter
      Law.new(name, bill, letter)
    end
  end
end
