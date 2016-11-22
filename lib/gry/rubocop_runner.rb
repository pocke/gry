module Gry
  # Run RuboCop with spwcify cops and config
  class RubocopRunner
    # @param cops [Array<String>] cop names. e.g.) ['Style/EmptyElse']
    # @param setting [Hash] e.g.) {'Style/EmptyElse' => {'EnforcedStyle' => 'both'}}
    def initialize(cops, setting)
      @cops = cops
      @setting = setting
      @tmp_setting_path = nil
    end

    def run
      prepare
      out = run_rubocop
      JSON.parse(out)
    ensure
      clean
    end


    private

    def prepare
      f = Tempfile.create(['gry-rubocop-config-', '.yml'])
      @tmp_setting_path = f.path

      f.write(YAML.dump(@setting))
      f.close
    end

    def run_rubocop
      # TODO: error handling
      only = @cops.map{|cop| "--only #{cop}"}.join(' ')
      conf = "--config #{@tmp_setting_path}"
      cmd = "rubocop #{only} #{conf} --format json"
      Gry.debug_log "Execute: #{cmd}"
      `#{cmd}`
    end

    def clean
      FileUtils.rm(@tmp_setting_path) if @tmp_setting_path
    end
  end
end
