module Gry
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run(writer)
      opt = Option.new(@argv)
      if opt.version
        rubocop_version, = *Open3.capture3('rubocop', '--verbose-version')
        writer.puts "gry #{VERSION} (RuboCop #{rubocop_version.chomp})"
        return
      end

      cops = opt.args.empty? ? RubocopAdapter.configurable_cops : opt.args
      if opt.fast
        cops.reject!{|cop| cop == 'Style/AlignHash'}
      end
      pilot_study = Gry::PilotStudy.new(cops, process: opt.process)

      bills = pilot_study.analyze
      # TODO: Specify the value from option
      congress = Congress.new(
        max_count: opt.max_count,
        min_difference: opt.min_difference,
      )
      laws = bills.map do |cop_name, bill|
        congress.discuss(cop_name, bill)
      end

      fmt = Formatter.new(display_disabled_cops: opt.display_disabled_cops)
      writer.puts fmt.format(laws)
    end
  end
end
