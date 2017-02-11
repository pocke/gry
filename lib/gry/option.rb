module Gry
  class Option
    attr_reader :args, :process, :version, :fast, :max_count, :min_difference, :display_disabled_cops, :metrics_percentile

    def initialize(argv)
      opt = OptionParser.new
      @version = false
      @process = Parallel.processor_count
      @fast = true
      @max_count = 10
      @min_difference = 10
      @display_disabled_cops = false
      @metrics_percentile = 95

      opt.banner = 'Usage: gry [options] [Cop1, Cop2, ...]'

      opt.on('-d', '--debug', 'Output debug log.') {Gry.debug_mode!}
      opt.on('-p', '--process=VAL', 'Number of parallel processes.') {|v| @process = v.to_i}
      opt.on('-v', '--version', 'Display version.') {@version = true}
      opt.on('--[no-]fast', 'Run only fast cops. Default: true') {|v| @fast = v}
      opt.on('--max-count=10', 'Upper limit of issues.') {|v| @max_count = v.to_i}
      opt.on('--min-difference=10', 'Lower limit of issues number difference') {|v| @min_difference = v.to_i}
      opt.on('--metrics-percentile=95', 'Percentile for allowed complex code') {|v| @metrics_percentile = v.to_i}
      opt.on('--display-disabled-cops', 'Display disabled cops') {|v| @display_disabled_cops = v}

      @args = opt.parse(argv)
    end
  end
end
