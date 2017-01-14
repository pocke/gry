module Gry
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run(writer)
      opt = Option.new(@argv)
      if opt.version
        rubocop_version, = *Open3.capture3('rubocop', '--verbose-version')
        puts "gry #{VERSION} (RuboCop #{rubocop_version.chomp})"
        return
      end

      cops = opt.all ? RubocopAdapter.configurable_cops : opt.args
      if opt.fast
        cops.reject!{|cop| cop == 'Style/AlignHash'}
      end
      analyzer = Gry::Analyzer.new(cops, process: opt.process)

      gry_result = analyzer.analyze
      writer.puts Formatter.format(gry_result)
    end
  end
end
