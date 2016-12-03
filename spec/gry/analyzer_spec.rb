require 'spec_helper'

describe Gry::Analyzer do
  describe '#analyze' do
    let(:analyzer){Gry::Analyzer.new(cops, parallel: parallel)}
    let(:parallel){true}
    subject(:analyze){analyzer.analyze}

    context 'with all cops' do
      let(:cops){Gry::RubocopAdapter.configurable_cops}

      it 'returns a hash' do
        expect(analyze).to be_a Hash
        expect(analyze.keys).to be_all{|key| cops.include?(key)}
        expect(analyze.values).to be_all{|value| value.is_a?(Hash)}
      end
    end
  end

  describe '#cop_configs' do
    let(:analyzer){Gry::Analyzer.new([cop_name], parallel: true)}
    let(:cop_name){'Style/AndOr'}
    let(:expected) do
      [
        {
          'Style/AndOr' => {
            'EnforcedStyle' => 'always'
          },
        },
        {
          'Style/AndOr' => {
            'EnforcedStyle' => 'conditionals'
          },
        }
      ]
    end
    let(:default_config) do
      {
        'Style/AndOr' => {
          'EnforcedStyle' => 'always',
          'SupportedStyles' => [
            'always',
            'conditionals'
          ]
        },
        'Style/BarePercentLiterals' => {
          'EnforcedStyle' => 'bare_percent',
          'SupportedStyles' => [
            'percent_q',
            'bare_percent'
          ]
        }
      }
    end

    it 'returns cop configs' do
      config = analyzer.__send__(:cop_configs, cop_name)
      expect(config).to eq expected
    end
  end
end
