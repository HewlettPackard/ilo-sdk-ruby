require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Cli do
  include_context 'cli context'

  describe '#version' do
    let(:command) { ILO_SDK::Cli.start(['version']) }

    before :each do
      allow_any_instance_of(ILO_SDK::Client).to receive(:rest_get).with('/redfish/v1/')
        .and_return(FakeResponse.new('RedfishVersion' => '1.0.0'))
    end

    it 'prints the gem version' do
      expect { command }.to output(/Gem Version: #{ILO_SDK::VERSION}/).to_stdout_from_any_process
    end

    it 'prints the appliance version' do
      expect { command }.to output(/iLO Redfish API version: 1.0.0/).to_stdout_from_any_process
    end

    it 'requires the url to be set' do
      ENV.delete('ILO_HOST')
      expect(STDOUT).to receive(:puts).with(/Gem Version/)
      expect(STDOUT).to receive(:puts).with(/iLO API version unknown/)
      command
    end
  end
end
