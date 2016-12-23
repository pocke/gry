module Gry
  class Option
    class ParseError < StandardError; end

    attr_reader :args, :all, :process, :version

    def initialize(argv)
      opt = OptionParser.new
      @all = false
      @version = false
      @process = Parallel.processor_count

      opt.on('-d', '--debug') {Gry.debug_mode!}
      opt.on('-a', '--all') {@all = true}
      opt.on('-p', '--process=VAL') {|v| @process = v.to_i}
      opt.on('-v', '--version') {@version = true}

      @args = opt.parse(argv)

      if @all && !@args.empty?
        raise ParseError, 'Do not specify cop name with --all option'
      end
    end
  end
end
