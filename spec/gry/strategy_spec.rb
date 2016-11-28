require 'spec_helper'

describe Gry::Strategy do
  describe '.results_to_config' do
    subject{Gry::Strategy.results_to_config(results, count_limit: count_limit)}

    context 'config is available' do
      let(:results) do
        {
          {'EnforcedStyle' => 'foo'} => 8,
          {'EnforcedStyle' => 'bar'} => 6,
          {'EnforcedStyle' => 'baz'} => 20,
        }
      end
      let(:count_limit){10}

      it {is_expected.to eq({'EnforcedStyle' => 'bar'})}
    end

    context 'with boundary value' do
      let(:results) do
        {
          {'EnforcedStyle' => 'foo'} => 30,
          {'EnforcedStyle' => 'bar'} => 20,
          {'EnforcedStyle' => 'baz'} => 10,
        }
      end
      let(:count_limit){10}

      it {is_expected.to eq({'EnforcedStyle' => 'baz'})}
    end

    context 'config is not available' do
      let(:results) do
        {
          {'EnforcedStyle' => 'foo'} => 30,
          {'EnforcedStyle' => 'bar'} => 20,
          {'EnforcedStyle' => 'baz'} => 10,
        }
      end
      let(:count_limit){9}

      it {is_expected.to be_nil}
    end
  end
end
