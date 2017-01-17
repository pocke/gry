require 'spec_helper'

describe Gry::Congress do
  describe '#discuss' do
    subject(:discuss){Gry::Congress.new(max_count: count_limit).discuss(name, bill)}

    context 'when accepts' do
      let(:bill) do
        {
          {'EnforcedStyle' => 'foo'} => 8,
          {'EnforcedStyle' => 'bar'} => 6,
          {'EnforcedStyle' => 'baz'} => 20,
        }
      end
      let(:name){'Style/FooBar'}
      let(:count_limit){10}

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
      let(:count_limit){10}

      it 'returns a law' do
        law = discuss
        is_asserted_by{ law.is_a? Gry::Law }
        is_asserted_by{ law.name == name }
        is_asserted_by{ law.letter ==  {'EnforcedStyle' => 'baz'} }
      end
    end

    context 'when bill is rejected' do
      let(:bill) do
        {
          {'EnforcedStyle' => 'foo'} => 30,
          {'EnforcedStyle' => 'bar'} => 20,
          {'EnforcedStyle' => 'baz'} => 10,
        }
      end
      let(:name){'Style/FooBar'}
      let(:count_limit){9}

      it {is_expected.to be_nil}
    end
  end
end
