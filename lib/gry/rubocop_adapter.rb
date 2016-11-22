module Gry
  module RubocopAdapter
    module_function

    def default_config
      RuboCop::ConfigLoader.default_configuration
    end

    def configurable_cops
      conf = RuboCop::ConfigLoader.default_configuration.to_h
      conf.select{|_key, value| value['SupportedStyles']}.keys
    end
  end
end
