require 'spec_helper'

describe Gry::Formatter do
  describe '.format' do
    context 'simple' do
      it 'retrns a YAML' do
        gry_result = {
          'Style/DotPosition' => {
            {
              'EnforcedStyle' => 'leading',
              'Enabled' => true,
            } => 10,
            {
              'EnforcedStyle' => 'trailing',
              'Enabled' => true,
            } => 20,
          }
        }

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: leading => 10
# EnforcedStyle: trailing => 20
Style/DotPosition:
  EnforcedStyle: leading
  Enabled: true
        END

        expect(Gry::Formatter.format(gry_result)).to eq expected
      end
    end

    context 'has two results' do
      it 'returns a YAML' do
        gry_result = {
          'Style/DotPosition' => {
            {
              'EnforcedStyle' => 'leading',
              'Enabled' => true,
            } => 10,
            {
              'EnforcedStyle' => 'trailing',
              'Enabled' => true,
            } => 20,
          },
          'Style/Alias' => {
            {
              'EnforcedStyle' => 'prefer_alias',
              'Enabled' => true,
            } => 42,
            {
              'EnforcedStyle' => 'prefer_alias_method',
              'Enabled' => true,
            } => 5,
          }
        }

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: leading => 10
# EnforcedStyle: trailing => 20
Style/DotPosition:
  EnforcedStyle: leading
  Enabled: true

# EnforcedStyle: prefer_alias => 42
# EnforcedStyle: prefer_alias_method => 5
Style/Alias:
  EnforcedStyle: prefer_alias_method
  Enabled: true
        END

        expect(Gry::Formatter.format(gry_result)).to eq expected
      end
    end

    context 'has a complex cop' do
      it 'returns a YAML' do
        gry_result = {
          'Style/SpaceInsideHashLiteralBraces' => {
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
          },
        }

        expected = <<-END
AllCops:
  TargetRubyVersion: 2.3

# EnforcedStyle: space, EnforcedStyleForEmptyBraces: no_space => 1
# EnforcedStyle: space, EnforcedStyleForEmptyBraces: space => 3
# EnforcedStyle: no_space, EnforcedStyleForEmptyBraces: no_space => 2
# EnforcedStyle: no_space, EnforcedStyleForEmptyBraces: space => 4
Style/SpaceInsideHashLiteralBraces:
  EnforcedStyle: space
  EnforcedStyleForEmptyBraces: no_space
  Enabled: true
        END

        expect(Gry::Formatter.format(gry_result)).to eq expected
      end
    end
  end
end
