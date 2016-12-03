require 'spec_helper'

describe Gry::RubocopAdapter do
  describe '.default_config' do
    it 'returns a RuboCop::Config' do
      expect(Gry::RubocopAdapter.default_config).to be_a RuboCop::Config
    end
  end

  describe '.configurable_cops' do
    it 'returns a Array of String' do
      cops = Gry::RubocopAdapter.configurable_cops
      expect(cops).to be_a Array
      expect(cops).not_to be_empty
      expect(cops).to be_all{|cop| cop.is_a? String}
      expect(cops).to be_include 'Style/Alias'
      expect(cops).not_to be_include 'Rails/NotNullColumn'
    end
  end

  describe '.configurable_styles' do
    shared_examples 'returns_configurable_styles' do |cop_name, expected|
      it "returns configurable styles for #{cop_name}" do
        cop_conf = Gry::RubocopAdapter.default_config[cop_name]
        styles = Gry::RubocopAdapter.configurable_styles(cop_conf)
        expect(styles).to eq expected
      end
    end

    include_examples 'returns_configurable_styles', 'Style/AndOr', %w[EnforcedStyle]
    include_examples 'returns_configurable_styles', 'Style/NumericLiteralPrefix', %w[EnforcedOctalStyle]
    include_examples 'returns_configurable_styles', 'Style/AlignHash', %w[
      EnforcedHashRocketStyle
      EnforcedColonStyle
      EnforcedLastArgumentHashStyle
    ]
    include_examples 'returns_configurable_styles', 'Rails/UniqBeforePluck', %w[EnforcedMode]
    include_examples 'returns_configurable_styles', 'Lint/BlockAlignment', %w[AlignWith]
    include_examples 'returns_configurable_styles', 'Rails/NotNullColumn', %w[]
  end

  describe '.to_supported_styles' do
    it 'returns a supported style name' do
      res = Gry::RubocopAdapter.to_supported_styles('EnforcedStyle')
      expect(res).to eq 'SupportedStyles'
    end
  end

  describe '.target_ruby_version' do
    it 'returns a version' do
      res = Gry::RubocopAdapter.target_ruby_version
      expect(res).to be_a Float
    end
  end
end
