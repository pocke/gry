require 'spec_helper'

describe Gry::Formatter do
  describe '.format' do
    context 'simple' do
      it 'retrns a YAML' do
        bill = {
          {
            'EnforcedStyle' => 'leading',
            'Enabled' => true,
          } => 10,
          {
            'EnforcedStyle' => 'trailing',
            'Enabled' => true,
          } => 20,
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

        expect(Gry::Formatter.format(laws)).to eq expected
      end
    end

    context 'has two results' do
      it 'returns a YAML' do
        laws = [
          Gry::Law.new('Style/DotPosition', {
            {
              'EnforcedStyle' => 'leading',
              'Enabled' => true,
            } => 10,
            {
              'EnforcedStyle' => 'trailing',
              'Enabled' => true,
            } => 20,
          },{
            'EnforcedStyle' => 'leading',
            'Enabled' => true,
          }),
          Gry::Law.new('Style/Alias', {
            {
              'EnforcedStyle' => 'prefer_alias',
              'Enabled' => true,
            } => 42,
            {
              'EnforcedStyle' => 'prefer_alias_method',
              'Enabled' => true,
            } => 5,
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

        expect(Gry::Formatter.format(laws)).to eq expected
      end
    end

    context 'has a complex cop' do
      it 'returns a YAML' do
        bill = {
          {
            'EnforcedStyle' => 'space',
            'EnforcedStyleForEmptyBraces' => 'no_space',
            'Enabled' => true,
          } => 1,
          {
            'EnforcedStyle' => 'space',
            'EnforcedStyleForEmptyBraces' => 'space',
            'Enabled' => true,
          } => 3,
          {
            'EnforcedStyle' => 'no_space',
            'EnforcedStyleForEmptyBraces' => 'no_space',
            'Enabled' => true,
          } => 2,
          {
            'EnforcedStyle' => 'no_space',
            'EnforcedStyleForEmptyBraces' => 'space',
            'Enabled' => true,
          } => 4,
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

        expect(Gry::Formatter.format(laws)).to eq expected
      end
    end
  end
end
