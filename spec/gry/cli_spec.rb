require 'spec_helper'
require 'stringio'

describe Gry::CLI do
  describe '#run' do
    include_context :chdir

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
      context 'with --fast' do
        let(:args){%w[--fast]}
        include_examples 'writes yaml'
      end

      context 'without args' do
        let(:args){%w[]}
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
