module Gry
  class Option
    class ParseError < StandardError; end

    attr_reader :args, :all

    def initialize(argv)
      opt = OptionParser.new
      @all = false

      opt.on('-d', '--debug') {Gry.debug_mode!}
      opt.on('-a', '--all') {@all = true}

      @args = opt.parse(argv)

      if @all && !@args.empty?
        raise ParseError, 'Do not specify cop name with --all option'
      end
    end
  end
end
