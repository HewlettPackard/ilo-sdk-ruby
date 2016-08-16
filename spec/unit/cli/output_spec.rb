require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Cli do
  include_context 'cli context'

  let(:cli) do
    ILO_SDK::Cli.new
  end

  describe '#output' do
    context 'with the default format' do
      it 'prints nil for nil' do
        expect { cli.instance_eval { output(nil) } }.to output("nil\n").to_stdout_from_any_process
      end

      it 'prints nil in arrays' do
        expect { cli.instance_eval { output([nil]) } }.to output("nil\n\nTotal: 1\n").to_stdout_from_any_process
      end

      it 'prints nil in hash keys and values' do
        expect { cli.instance_eval { output(nil => nil) } }.to output("nil: nil\n").to_stdout_from_any_process
      end

      it 'prints single values' do
        expect { cli.instance_eval { output('val') } }.to output("val\n").to_stdout_from_any_process
      end

      it 'prints arrays' do
        expect { cli.instance_eval { output(%w(val val2)) } }.to output("val\nval2\n\nTotal: 2\n").to_stdout_from_any_process
      end

      it 'prints nested arrays' do
        expect { cli.instance_eval { output(['val', %w(val2 val3)]) } }.to output("val\n  val2\n  val3\n\nTotal: 2\n").to_stdout_from_any_process
      end

      it 'prints hashes' do
        expect { cli.instance_eval { output(key: 'val', key2: 'val2') } }.to output("key: val\nkey2: val2\n").to_stdout_from_any_process
      end

      it 'prints nested hashes' do
        expect { cli.instance_eval { output(key: { key2: 'val2' }) } }.to output("key:\n  key2: val2\n").to_stdout_from_any_process
      end
    end
  end
end
