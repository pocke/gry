require 'spec_helper'

describe Gry::Analyzer do
  describe '#analyze' do
    shared_examples 'returns_a_valid_rubocop_yml' do
      it 'returns a valid .rubocop.yml' do
        expect(analyze).to be_a Hash
        expect(analyze.keys).to be_all{|key| cops.include?(key)}
        expect(analyze.values).to be_all{|value| value.is_a?(Hash)}
      end
    end

    let(:analyzer){Gry::Analyzer.new(cops, parallel: parallel)}
    let(:parallel){true}
    subject(:analyze){analyzer.analyze}

    context 'with all cops' do
      let(:cops){Gry::RubocopAdapter.configurable_cops}

      include_examples 'returns_a_valid_rubocop_yml'
    end

    context 'non parallel mode' do
      let(:parallel){false}
      let(:cops){Gry::RubocopAdapter.configurable_cops}

      include_examples 'returns_a_valid_rubocop_yml'
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

    it 'returns cop configs' do
      config = analyzer.__send__(:cop_configs, cop_name)
      expect(config).to eq expected
    end
  end
end
