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
    end
  end
end
