module Gry
  class Option
    attr_reader :args

    def initialize(argv)
      opt = OptionParser.new

      opt.on('-d', '--debug') {Gry.debug_mode!}

      @args = opt.parse(argv)
    end
  end
end
