describe Gry::Formatter do
  let(:fmt){Gry::Formatter.new(display_disabled_cops: display_disabled_cops)}
  let(:display_disabled_cops){false}

  describe '.format' do
    def offenses(count)
      [{'message' => 'hoge'}] * count
    end

    context 'simple' do
      it 'retrns a YAML' do
        bill = {
          {
            'EnforcedStyle' => 'leading',
            'Enabled' => true,
          } => offenses(10),
          {
            'EnforcedStyle' => 'trailing',
            'Enabled' => true,
          } => offenses(20),
        }
        letter = {
          'EnforcedStyle' => 'leading',
          'Enabled' => true,
        }

        laws = [
          Gry::Law.new('Style/DotPosition', bill, letter)
        ]

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: leading => 10 offenses
# EnforcedStyle: trailing => 20 offenses
Style/DotPosition:
  EnforcedStyle: leading
  Enabled: true
        END

        expect(fmt.format(laws)).to eq expected
      end
    end

    context 'with a metrics cop' do
      it 'retrns a YAML' do
        bill = {
          {
            'EnforcedStyle' => 'leading',
            'Enabled' => true,
          } => offenses(10),
        }
        letter = {
          'Max' => 40,
          'Enabled' => true,
        }

        laws = [
          Gry::Law.new('Metrics/LineLength', bill, letter)
        ]

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

Metrics/LineLength:
  Max: 40
  Enabled: true
        END

        expect(fmt.format(laws)).to eq expected
      end
    end

    context 'has two results' do
      it 'returns a YAML' do
        laws = [
          Gry::Law.new('Style/DotPosition', {
            {
              'EnforcedStyle' => 'leading',
              'Enabled' => true,
            } => offenses(10),
            {
              'EnforcedStyle' => 'trailing',
              'Enabled' => true,
            } => offenses(20),
          },{
            'EnforcedStyle' => 'leading',
            'Enabled' => true,
          }),
          Gry::Law.new('Style/Alias', {
            {
              'EnforcedStyle' => 'prefer_alias',
              'Enabled' => true,
            } => offenses(42),
            {
              'EnforcedStyle' => 'prefer_alias_method',
              'Enabled' => true,
            } => offenses(5),
          },{
            'EnforcedStyle' => 'prefer_alias_method',
            'Enabled' => true,
          })
        ]
        
        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: leading => 10 offenses
# EnforcedStyle: trailing => 20 offenses
Style/DotPosition:
  EnforcedStyle: leading
  Enabled: true

# EnforcedStyle: prefer_alias => 42 offenses
# EnforcedStyle: prefer_alias_method => 5 offenses
Style/Alias:
  EnforcedStyle: prefer_alias_method
  Enabled: true
        END

        expect(fmt.format(laws)).to eq expected
      end
    end

    context 'has a complex cop' do
      it 'returns a YAML' do
        bill = {
          {
            'EnforcedStyle' => 'space',
            'EnforcedStyleForEmptyBraces' => 'no_space',
            'Enabled' => true,
          } => offenses(1),
          {
            'EnforcedStyle' => 'space',
            'EnforcedStyleForEmptyBraces' => 'space',
            'Enabled' => true,
          } => offenses(3),
          {
            'EnforcedStyle' => 'no_space',
            'EnforcedStyleForEmptyBraces' => 'no_space',
            'Enabled' => true,
          } => offenses(2),
          {
            'EnforcedStyle' => 'no_space',
            'EnforcedStyleForEmptyBraces' => 'space',
            'Enabled' => true,
          } => offenses(4),
        }
        letter = {
          'EnforcedStyle' => 'space',
          'EnforcedStyleForEmptyBraces' => 'no_space',
          'Enabled' => true,
        }

        laws = [
          Gry::Law.new('Style/SpaceInsideHashLiteralBraces', bill, letter)
        ]

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: space, EnforcedStyleForEmptyBraces: no_space => 1 offense
# EnforcedStyle: space, EnforcedStyleForEmptyBraces: space => 3 offenses
# EnforcedStyle: no_space, EnforcedStyleForEmptyBraces: no_space => 2 offenses
# EnforcedStyle: no_space, EnforcedStyleForEmptyBraces: space => 4 offenses
Style/SpaceInsideHashLiteralBraces:
  EnforcedStyle: space
  EnforcedStyleForEmptyBraces: no_space
  Enabled: true
        END

        expect(fmt.format(laws)).to eq expected
      end
    end

    context 'with --display-disabled-cops' do
      let(:display_disabled_cops){true}

      it 'retrns a YAML' do
        bill = {
          {
            'EnforcedStyle' => 'leading',
            'Enabled' => true,
          } => offenses(10),
          {
            'EnforcedStyle' => 'trailing',
            'Enabled' => true,
          } => offenses(20),
        }
        letter = {
          'EnforcedStyle' => 'leading',
          'Enabled' => true,
        }

        laws = [
          Gry::Law.new('Style/DotPosition', bill, letter)
        ]

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: leading => 10 offenses
# EnforcedStyle: trailing => 20 offenses
Style/DotPosition:
  EnforcedStyle: leading
  Enabled: true
        END

        expect(fmt.format(laws)).to eq expected
      end

      it 'returns a comment if disabled' do
        bill = {
          {
            'EnforcedStyle' => 'leading',
            'Enabled' => true,
          } => offenses(10),
          {
            'EnforcedStyle' => 'trailing',
            'Enabled' => true,
          } => offenses(20),
        }

        laws = [
          Gry::Law.new('Style/DotPosition', bill, nil)
        ]

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: leading => 10 offenses
# EnforcedStyle: trailing => 20 offenses
Style/DotPosition:
  Enabled: false
        END

        expect(fmt.format(laws)).to eq expected
      end
    end
  end
end
