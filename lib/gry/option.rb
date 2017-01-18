module Gry
  class Option
    class ParseError < StandardError; end

    attr_reader :args, :all, :process, :version, :fast, :max_count, :min_difference

    def initialize(argv)
      opt = OptionParser.new
      @all = false
      @version = false
      @process = Parallel.processor_count
      @fast = false
      @max_count = 10
      @min_difference = 10

      opt.banner = 'Usage: gry [options] [Cop1, Cop2, ...]'

      opt.on('-d', '--debug', 'Output debug log.') {Gry.debug_mode!}
      opt.on('-a', '--all', 'Run for all cops.') {@all = true}
      opt.on('-p', '--process=VAL', 'Number of parallel processes.') {|v| @process = v.to_i}
      opt.on('-v', '--version', 'Display version.') {@version = true}
      opt.on('-f', '--fast', 'Run only fast cops.') {@fast = true}
      opt.on('--max-count=10', 'Upper limit of issues.') {|v| @max_count = v.to_i}
      opt.on('--min-difference=10', 'Lower limit of issues number difference') {|v| @min_difference = v.to_i}

      @args = opt.parse(argv)

      if @all && !@args.empty?
        raise ParseError, 'Do not specify cop name with --all option'
      end
    end
  end
end
