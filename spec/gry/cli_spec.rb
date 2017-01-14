require 'spec_helper'
require 'stringio'

describe Gry::CLI do
  describe '#run' do

    let(:cli){Gry::CLI.new(args)}
    let(:out){StringIO.new}
    subject(:run){cli.run(out)}

    shared_examples 'writes yaml' do
      it 'write a yaml' do
        run
        result = out.string
        is_asserted_by{ !result.empty? }
        is_asserted_by{ YAML.load(result).is_a? Hash }
      end
    end

    unless ENV['DONT_RUN_SLOW_SPEC']
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

    context 'with --version' do
      let(:args){%w[--version]}

      it 'writes a version' do
        run
        result = out.string
        is_asserted_by{ !result.empty? }
        is_asserted_by{ result.start_with?("gry #{Gry::VERSION}") }
      end
    end
  end
end
