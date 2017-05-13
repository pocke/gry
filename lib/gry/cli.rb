module Gry
  class CLI
    CACHE_DIR = Pathname(ENV['XDG_CACHE_HOME'] || '~/.cache').expand_path / 'gry'

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

      bills = (opt.cache && restore_cache(cops)) || begin
        pilot_study = Gry::PilotStudy.new(cops, process: opt.process)
        pilot_study.analyze.tap do |b|
          save_cache(b, cops)
        end
      end
      if opt.raw
        writer.puts JSON.generate(bills)
        return
      end

      congress = Congress.new(
        max_count: opt.max_count,
        min_difference: opt.min_difference,
        metrics_percentile: opt.metrics_percentile,
      )
      laws = bills.map do |cop_name, bill|
        congress.discuss(cop_name, bill)
      end

      fmt = Formatter.new(display_disabled_cops: opt.display_disabled_cops)
      writer.puts fmt.format(laws)
    end

    private

    def save_cache(bills, cops)
      Dir.mkdir(CACHE_DIR) unless CACHE_DIR.exist?
      cache = {
        bills: bills,
        cops: cops,
        created_at: Time.now,
      }
      File.write(cache_path, Marshal.dump(cache))
    end

    def restore_cache(cops)
      return unless cache_path.exist?
      cache = Marshal.load(File.read(cache_path))

      return unless cops == cache[:cops]

      cached_time = cache[:created_at]
      not_changed = RubocopAdapter.find_target_files.map(&:chomp).all?{|file| File.ctime(file) < cached_time}
      return unless not_changed

      return cache[:bills]
    end

    def cache_path
      CACHE_DIR / Digest::SHA1.hexdigest(Dir.pwd)
    end
  end
end
