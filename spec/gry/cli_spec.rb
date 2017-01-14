require 'spec_helper'
require 'stringio'

describe Gry::CLI do
  describe '#run' do
    break if ENV['DONT_RUN_SLOW_SPEC']

    let(:cli){Gry::CLI.new(args)}
    let(:out){StringIO.new}
    subject(:run){cli.run(out)}

    shared_examples 'writes yaml' do
      it 'write a yaml' do
        run
        result = out.string
        is_asserted_by{ result.is_a? String }
        is_asserted_by{ !result.empty? }
        is_asserted_by{ YAML.load(result).is_a? Hash }
      end
    end

    context 'with --all --fast' do
      let(:args){%w[--all --fast]}
      include_examples 'writes yaml'
    end

    context 'with --all' do
      let(:args){%w[--all]}
      include_examples 'writes yaml'
    end

    context 'when a cop name is specified' do
      let(:args){%w[Style/AndOr]}
      include_examples 'writes yaml'
    end
  end
end
