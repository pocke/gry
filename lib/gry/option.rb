module Gry
  class Option
    class ParseError < StandardError; end

    attr_reader :args, :all, :process

    def initialize(argv)
      opt = OptionParser.new
      @all = false
      @process = Parallel.processor_count

      opt.on('-d', '--debug') {Gry.debug_mode!}
      opt.on('-a', '--all') {@all = true}
      opt.on('-p', '--process=VAL') {|v| @process = v}

      @args = opt.parse(argv)

      if @all && !@args.empty?
        raise ParseError, 'Do not specify cop name with --all option'
      end
    end
  end
end
