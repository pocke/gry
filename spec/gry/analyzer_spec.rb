require 'spec_helper'

describe Gry::Analyzer do
  describe '#analyze' do
    break if ENV['DONT_RUN_SLOW_SPEC']

    shared_examples 'returns_a_valid_rubocop_yml' do
      it 'returns a valid .rubocop.yml' do
        expect(analyze).to be_a Hash
        expect(analyze.keys).to be_all{|key| cops.include?(key)}
        expect(analyze.values).to be_all{|value| value.is_a?(Hash)}
      end
    end

    let(:analyzer){Gry::Analyzer.new(cops, process: process)}
    let(:process){Parallel.processor_count}
    subject(:analyze){analyzer.analyze}

    context 'with all cops' do
      let(:cops){Gry::RubocopAdapter.configurable_cops}

      include_examples 'returns_a_valid_rubocop_yml'
    end

    context 'non parallel mode' do
      let(:process){1}
      let(:cops){Gry::RubocopAdapter.configurable_cops}

      include_examples 'returns_a_valid_rubocop_yml'
    end
  end

  describe '#cop_configs' do
    shared_examples 'returns_cop_configs' do |cop_name, expected|
      it "returns cop configs for #{cop_name}" do
        analyzer = Gry::Analyzer.new([cop_name], process: 0)
        config = analyzer.__send__(:cop_configs, cop_name)
        expect(config).to eq expected
      end
    end

    include_examples 'returns_cop_configs', 'Style/AndOr', [
      {
        'Style/AndOr' => {
          'EnforcedStyle' => 'always',
          'Enabled' => true,
        },
      },
      {
        'Style/AndOr' => {
          'EnforcedStyle' => 'conditionals',
          'Enabled' => true,
        },
      }
    ]

    include_examples 'returns_cop_configs', 'Style/NumericLiteralPrefix', [
      {
        'Style/NumericLiteralPrefix' => {
          'EnforcedOctalStyle' => 'zero_with_o',
          'Enabled' => true,
        },
      },
      {
        'Style/NumericLiteralPrefix' => {
          'EnforcedOctalStyle' => 'zero_only',
          'Enabled' => true,
        },
      }
    ]

    include_examples 'returns_cop_configs', 'Style/AlignHash', [
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },


      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },


      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Style/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

    ]

  end
end
