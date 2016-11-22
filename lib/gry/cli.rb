module Gry
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      opt = Option.new(@argv)
      analyzer = Gry::Analyzer.new(opt.args)
      puts YAML.dump(analyzer.analyze)
    end
  end
end
