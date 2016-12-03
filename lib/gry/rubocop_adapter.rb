module Gry
  module RubocopAdapter
    module_function

    def default_config
      RuboCop::ConfigLoader.default_configuration
    end

    def configurable_cops
      conf = RuboCop::ConfigLoader.default_configuration.to_h
      conf.reject{|_key, cop_conf| configurable_styles(cop_conf).empty?}.keys
    end

    # @param cop_conf [Hash]
    def configurable_styles(cop_conf)
      cop_conf.keys.select do |key, _value|
        key.start_with?('Enforced') || %w[AlignWith IndentWhenRelativeTo].include?(key)
      end
    end

    def to_supported_styles(enforced_style)
      RuboCop::Cop::Util.to_supported_styles(enforced_style)
    end

    def target_ruby_version
      RuboCop::ConfigStore.new.for(Dir.pwd).target_ruby_version
    end
  end
end
