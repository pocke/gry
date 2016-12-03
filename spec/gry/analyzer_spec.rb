require 'spec_helper'

describe Gry::Analyzer do
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
