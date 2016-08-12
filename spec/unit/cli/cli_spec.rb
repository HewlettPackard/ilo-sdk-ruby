require_relative './../../spec_helper'

# Class to mock Kernel interractions
class FakeKernel
  def self.exit(*)
  end
end

# Class to mock STDOUT, etc.
class FakeOut < IO
  def self.puts(*)
  end
end

RSpec.describe ILO_SDK::Cli::Runner do
  include_context 'cli context'

  describe '#new' do
    it 'can be initialized' do
      expect { described_class.new(ARGV) }.to_not raise_error
    end
  end

  describe '#execute!' do
    it 'exits with 0 when the runner returns without errors' do
      expect(ILO_SDK::Cli).to receive(:start).and_return(true)
      expect(FakeKernel).to receive(:exit).with(0).and_return(true)
      r = described_class.new(ARGV, STDIN, STDOUT, STDERR, FakeKernel)
      expect { r.execute! }.to_not raise_error
    end

    it 'exits with 1 when the runner returns with an error' do
      expect(ILO_SDK::Cli).to receive(:start).and_raise('FakeError')
      expect(FakeKernel).to receive(:exit).with(1).and_return(true)
      expect(FakeOut).to receive(:puts).with(/FakeError/).and_return(true)
      expect(FakeOut).to receive(:puts).with(/from/).and_return(true)
      r = described_class.new(ARGV, STDIN, STDOUT, FakeOut, FakeKernel)
      expect { r.execute! }.to_not raise_error
    end
  end
end
