module Gry
  class Option
    class ParseError < StandardError; end

    attr_reader :args, :all, :parallel

    def initialize(argv)
      opt = OptionParser.new
      @all = false
      @parallel = true

      opt.on('-d', '--debug') {Gry.debug_mode!}
      opt.on('-a', '--all') {@all = true}
      opt.on('--[no-]parallel') {|v| @parallel = v}

      @args = opt.parse(argv)

      if @all && !@args.empty?
        raise ParseError, 'Do not specify cop name with --all option'
      end
    end
  end
end
