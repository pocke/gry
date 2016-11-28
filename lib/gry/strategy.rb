module Gry
  # Strategy decides a rule config from rubocop results.
  module Strategy
    # The method returns 
    # @param results [Hash{Hash => Integer}] rubocop results
    #   {
    #     {config1} => 20,
    #     {config2} =>  0,
    #     {config3} => 10,
    #   }
    # @return [Hash{}] returns a config decided from received configs
    #   {
    #     EnforcedStyle: 'foobar',
    #   }
    # @return [NilClass] if config is not available, retunrs nil
    def self.results_to_config(results, count_limit: 10)
      results
        .select{|_conf, count| count <= count_limit }
        .sort_by{|_conf, count| count}
        .first # to get minimum conf and count
        &.first # to get conf
    end
  end
end
