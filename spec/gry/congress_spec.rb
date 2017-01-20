require 'spec_helper'

describe Gry::Congress do
  describe '#discuss' do
    subject(:discuss){Gry::Congress.new(max_count: max_count, min_difference: min_difference).discuss(name, bill)}
    let(:max_count){10}
    let(:min_difference){10}

    context 'when accepts' do
      let(:bill) do
        {
          {'EnforcedStyle' => 'foo'} => 17,
          {'EnforcedStyle' => 'bar'} => 6,
          {'EnforcedStyle' => 'baz'} => 20,
        }
      end
      let(:name){'Style/FooBar'}

      it 'returns a law' do
        law = discuss
        is_asserted_by{ law.is_a? Gry::Law }
        is_asserted_by{ law.name == name }
        is_asserted_by{ law.letter ==  {'EnforcedStyle' => 'bar'} }
      end
    end


    context 'with boundary value' do
      let(:bill) do
        {
          {'EnforcedStyle' => 'foo'} => 30,
          {'EnforcedStyle' => 'bar'} => 20,
          {'EnforcedStyle' => 'baz'} => 10,
        }
      end
      let(:name){'Style/FooBar'}

      it 'returns a law' do
        law = discuss
        is_asserted_by{ law.is_a? Gry::Law }
        is_asserted_by{ law.name == name }
        is_asserted_by{ law.letter ==  {'EnforcedStyle' => 'baz'} }
      end
    end

    context 'when bill is rejected by max_count' do
      let(:bill) do
        {
          {'EnforcedStyle' => 'foo'} => 30,
          {'EnforcedStyle' => 'bar'} => 20,
          {'EnforcedStyle' => 'baz'} => 10,
        }
      end
      let(:name){'Style/FooBar'}
      let(:max_count){9}

      it 'returns a law' do
        law = discuss
        is_asserted_by{ law.is_a? Gry::Law }
        is_asserted_by{ law.name == name }
        is_asserted_by{ law.letter.nil? }
      end
    end

    context 'when bill is rejected by min_difference' do
      let(:bill) do
        {
          {'EnforcedStyle' => 'foo'} => 30,
          {'EnforcedStyle' => 'bar'} => 20,
          {'EnforcedStyle' => 'baz'} => 10,
        }
      end
      let(:name){'Style/FooBar'}
      let(:min_difference){20}

      it 'returns a law' do
        law = discuss
        is_asserted_by{ law.is_a? Gry::Law }
        is_asserted_by{ law.name == name }
        is_asserted_by{ law.letter.nil? }
      end
    end
  end
end
