require 'spec_helper'

describe Gry::RubocopRunner do
  describe '.new' do
    it 'sets @setting' do
      setting_arg = {
        'Style/AndOr' => {
          'EnforcedStyle' => 'always',
          'Enabled' => true,
        }
      }

      runner = Gry::RubocopRunner.new(['Style/AndOr'], setting_arg)
      setting = runner.instance_variable_get(:@setting)
      expect(setting['AllCops']['TargetRubyVersion']).to eq Gry::RubocopAdapter.target_ruby_version
      expect(setting['Style/AndOr']).to eq setting_arg['Style/AndOr']
    end
  end
end
