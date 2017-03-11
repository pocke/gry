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

  describe '#parse_stderr' do
    let(:stderr){<<-END}
An error occurred while Style/AndOr cop was inspecting /home/pocke/ghq/github.com/bbatsov/rubocop/spec/rubocop/node_pattern_spec.rb.
To see the complete backtrace run rubocop -d.
An error occurred while Rails/RequestReferer cop was inspecting /home/pocke/ghq/github.com/bbatsov/rubocop/spec/rubocop/node_pattern_spec.rb.
To see the complete backtrace run rubocop -d.
An error occurred while Style/AndOr cop was inspecting /home/pocke/ghq/github.com/bbatsov/rubocop/spec/rubocop/node_pattern_spec.rb.
To see the complete backtrace run rubocop -d.
    END

    let(:setting_arg){{
      'Style/AndOr' => {
        'EnforcedStyle' => 'always',
        'Enabled' => true,
      }
    }}

    subject{Gry::RubocopRunner.new(['Style/AndOr'], setting_arg).__send__(:parse_stderr, stderr)}

    it {is_expected.to eq %w[Style/AndOr Rails/RequestReferer]}
  end
end
