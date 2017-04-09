module Gry
  module RubocopAdapter
    module_function

    def default_config
      RuboCop::ConfigLoader.default_configuration
    end

    def configurable_cops
      conf = RuboCop::ConfigLoader.default_configuration.to_h
      conf
        .select{|key, cop_conf| !enforced_styles(cop_conf).empty? || metrics_cop?(key) }
        .reject{|key, _cop_conf| !rails? && key.start_with?('Rails/')}
        .select{|key, _cop_conf| conf = config_specified_by_user.for_cop(key); conf.empty? || conf.keys == ['Enabled']} # Ignore always configured cops
        .keys
    end

    # @param cop_conf [Hash]
    def enforced_styles(cop_conf)
      cop_conf.keys.select do |key|
        key.start_with?('Enforced')
      end
    end

    # @param cop_name [String]
    # @return [Boolean]
    def metrics_cop?(cop_name)
      return false unless cop_name.start_with?('Metrics')
      # https://github.com/bbatsov/rubocop/pull/4055
      exclude_cops = Gem::Version.new(RuboCop::Version.version) >= Gem::Version.new('0.48.0') ?
        %w[Metrics/BlockNesting] :
        %w[Metrics/ParameterLists Metrics/BlockNesting]
      !exclude_cops.include?(cop_name)
    end

    def to_supported_styles(enforced_style)
      RuboCop::Cop::Util.to_supported_styles(enforced_style)
    end

    def target_ruby_version
      current_config.target_ruby_version
    end

    def rails?
      return @rails if defined?(@rails)
      @rails = current_config.to_h.dig('Rails', 'Enabled') ||
        File.exist?('./bin/rails') ||
        File.exist?('./script/rails')
    end

    def current_config
      RuboCop::ConfigStore.new.for(Dir.pwd)
    end

    def config_specified_by_user
      path = RuboCop::ConfigLoader.configuration_file_for(Dir.pwd)
      if path == RuboCop::ConfigLoader::DEFAULT_FILE
        RuboCop::Config.new
      else
        RuboCop::ConfigLoader.load_file(path)
      end
    end

    def config_base
      base = {
        'AllCops' => {
          'TargetRubyVersion' => RubocopAdapter.target_ruby_version,
        },
      }
      return base unless rails?
      base.merge({
        'Rails' => {
          'Enabled' => true,
        }
      })
    end
  end
end
