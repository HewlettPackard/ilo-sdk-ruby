require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Cli do
  include_context 'cli context'

  describe '#console' do
    let(:command) { ILO_SDK::Cli.start(['console']) }

    context 'with a valid @client object' do
      it 'starts a Pry session' do
        expect(Pry).to receive(:start).and_return true
        expect(STDOUT).to receive(:puts).with(/Connected to/)
        expect(STDOUT).to receive(:puts).with(/HINT: The @client object is available to you/)
        allow_any_instance_of(Object).to receive(:warn).with(/was not found/).and_return true
        command
      end
    end

    context 'with no @client object' do
      it 'starts a Pry session' do
        expect(ILO_SDK::Client).to receive(:new).and_raise 'Error'
        expect(Pry).to receive(:start).and_return true
        expect(STDOUT).to receive(:puts).with(/WARNING: Couldn't connect to/)
        allow_any_instance_of(Object).to receive(:warn).with(/was not found/).and_return true
        command
      end
    end
  end
end
