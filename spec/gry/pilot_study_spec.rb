describe Gry::PilotStudy do
  describe '#analyze' do
    break if ENV['DONT_RUN_SLOW_SPEC']

    include_context :chdir

    shared_examples 'returns_a_valid_rubocop_yml' do
      it 'returns a valid .rubocop.yml' do
        result = analyze
        expect(result).to be_a Hash
        result.keys.each do |key|
          is_asserted_by{ key.is_a? String }
        end

        result.values.each do |value|
          is_asserted_by{ value.is_a? Hash }
          value.keys.each do |key|
            is_asserted_by{ key.is_a? Hash }
          end

          value.values.each do |v|
            is_asserted_by{ v.is_a? Array }
            v.each do |offence|
              is_asserted_by{ offence.is_a? Hash }
              is_asserted_by{ !offence.empty? }
              is_asserted_by{ offence['message'].is_a? String }
            end
          end
        end
      end
    end

    let(:analyzer){Gry::PilotStudy.new(cops, process: process)}
    let(:process){Parallel.processor_count}
    subject(:analyze){analyzer.analyze}

    context 'with all cops' do
      let(:cops){Gry::RubocopAdapter.configurable_cops}

      include_examples 'returns_a_valid_rubocop_yml'
    end

    context 'with fast cops only' do
      let(:cops)  {
        Gry::RubocopAdapter.configurable_cops
          .reject{|cop| cop == 'Layout/AlignHash'}
      }

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
        analyzer = Gry::PilotStudy.new([cop_name], process: 0)
        config = analyzer.__send__(:cop_configs, cop_name)
        expect(config).to eq expected
      end
    end

    include_examples 'returns_cop_configs', 'Metrics/AbcSize', [
      {
        'Metrics/AbcSize' => {
          'Enabled' => true,
          'Max' => 0,
        },
      },
    ]

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

    include_examples 'returns_cop_configs', 'Layout/AlignHash', [
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'key',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },


      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'separator',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },


      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'key',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'separator',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_inspect',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'always_ignore',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_implicit',
          'Enabled' => true,
        },
      },
      {
        'Layout/AlignHash' => {
          'EnforcedHashRocketStyle' => 'table',
          'EnforcedColonStyle' => 'table',
          'EnforcedLastArgumentHashStyle' => 'ignore_explicit',
          'Enabled' => true,
        },
      },

    ]

  end
end
