module Gry
  class Option
    class ParseError < StandardError; end

    attr_reader :args, :all, :process, :version, :fast

    def initialize(argv)
      opt = OptionParser.new
      @all = false
      @version = false
      @process = Parallel.processor_count
      @fast = false

      opt.on('-d', '--debug') {Gry.debug_mode!}
      opt.on('-a', '--all') {@all = true}
      opt.on('-p', '--process=VAL') {|v| @process = v.to_i}
      opt.on('-v', '--version') {@version = true}
      opt.on('-f', '--fast') {@fast = true}

      @args = opt.parse(argv)

      if @all && !@args.empty?
        raise ParseError, 'Do not specify cop name with --all option'
      end
    end
  end
end
