module Gry
  module RubocopAdapter
    module_function

    def default_config
      RuboCop::ConfigLoader.default_configuration
    end

    def configurable_cops
      conf = RuboCop::ConfigLoader.default_configuration.to_h
      conf
        .reject{|_key, cop_conf| configurable_styles(cop_conf).empty?}
        .reject{|key, _cop_conf| !rails? && key.start_with?('Rails/')}
        .keys
    end

    # @param cop_conf [Hash]
    def configurable_styles(cop_conf)
      cop_conf.keys.select do |key|
        key.start_with?('Enforced')
      end
    end

    def to_supported_styles(enforced_style)
      RuboCop::Cop::Util.to_supported_styles(enforced_style)
    end

    def target_ruby_version
      current_config.target_ruby_version
    end

    def rails?
      @rails ||= current_config.to_h.dig('Rails', 'Enabled') ||
        File.exist?('./bin/rails') ||
        File.exist?('./script/rails')
    end

    def current_config
      RuboCop::ConfigStore.new.for(Dir.pwd)
    end
  end
end
