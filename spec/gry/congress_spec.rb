require 'spec_helper'

describe Gry::Congress do
  describe '#discuss' do
    subject(:discuss) do
      Gry::Congress.new(
        max_count: max_count,
        min_difference: min_difference,
        metrics_percentile: metrics_percentile,
      ).discuss(name, bill)
    end
    let(:max_count){10}
    let(:min_difference){10}
    let(:metrics_percentile){95}

    def offenses(count)
      [{'message' => 'hoge'}] * count
    end

    context 'when accepts' do
      let(:bill) do
        {
          {'EnforcedStyle' => 'foo'} => offenses(17),
          {'EnforcedStyle' => 'bar'} => offenses(6),
          {'EnforcedStyle' => 'baz'} => offenses(20),
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
          {'EnforcedStyle' => 'foo'} => offenses(30),
          {'EnforcedStyle' => 'bar'} => offenses(20),
          {'EnforcedStyle' => 'baz'} => offenses(10),
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
          {'EnforcedStyle' => 'foo'} => offenses(30),
          {'EnforcedStyle' => 'bar'} => offenses(20),
          {'EnforcedStyle' => 'baz'} => offenses(10),
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
          {'EnforcedStyle' => 'foo'} => offenses(30),
          {'EnforcedStyle' => 'bar'} => offenses(20),
          {'EnforcedStyle' => 'baz'} => offenses(10),
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

    context 'when metrics cop' do
      let(:bill) do
        {
          {'Max' => 0} => [
            # 20 * 30, 30 * 30, 80 * 30, 101 ~ 110
            [{'message' => 'Line is too long. [20/0]'}] * 30,
            [{'message' => 'Line is too long. [30/0]'}] * 30,
            [{'message' => 'Line is too long. [80/0]'}] * 30,
            {'message' => 'Line is too long. [101/0]'},
            {'message' => 'Line is too long. [102/0]'},
            {'message' => 'Line is too long. [103/0]'},
            {'message' => 'Line is too long. [104/0]'},
            {'message' => 'Line is too long. [105/0]'},
            {'message' => 'Line is too long. [106/0]'},
            {'message' => 'Line is too long. [107/0]'},
            {'message' => 'Line is too long. [108/0]'},
            {'message' => 'Line is too long. [109/0]'},
            {'message' => 'Line is too long. [110/0]'},
          ].flatten,
        }
      end
      let(:name){'Metrics/LineLength'}

      it 'returns a law with 95 percentile max' do
        law = discuss
        is_asserted_by{ law.is_a? Gry::Law }
        is_asserted_by{ law.name == name }
        is_asserted_by{ law.letter ==  {'Enabled' => true, 'Max' => 105} }
      end
    end
  end
end
