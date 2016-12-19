module Gry
  # Run RuboCop with spwcify cops and config
  class RubocopRunner
    # @param cops [Array<String>] cop names. e.g.) ['Style/EmptyElse']
    # @param setting [Hash] e.g.) {'Style/EmptyElse' => {'EnforcedStyle' => 'both'}}
    def initialize(cops, setting)
      @cops = cops
      setting_base = RubocopAdapter.config_base
      @setting = setting_base.merge(setting)
      @tmp_setting_path = nil
    end

    def run
      prepare
      stdout, stderr = run_rubocop
      [JSON.parse(stdout), parse_stderr(stderr)]
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
      cmd = %W[
        rubocop
        --only #{@cops.join(',')}
        --config #{@tmp_setting_path}
        --format json
      ]
      Gry.debug_log "Execute: #{cmd.join(' ')}"
      stdout, stderr, _status = *Open3.capture3(*cmd)
      Gry.debug_log stderr
      [stdout, stderr]
    end

    def clean
      FileUtils.rm(@tmp_setting_path) if @tmp_setting_path && !Gry.debug?
    end

    # @param stderr [String] stderr output of RuboCop
    # @return [Array<String>] crashed cop list
    def parse_stderr(stderr)
      stderr
        .scan(%r!An error occurred while ([\w/]+) cop was inspecting!)
        .flatten
        .uniq
    end
  end
end
