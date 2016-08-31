require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Cli do
  include_context 'cli context'

  describe '#login' do
    let(:command) { ILO_SDK::Cli.start(['login']) }

    it 'prints a success message' do
      expect_any_instance_of(ILO_SDK::Client).to receive(:rest_get).with('/redfish/v1/Sessions/')
        .and_return(FakeResponse.new)
      expect { command }.to output(/Login Successful!/).to_stdout_from_any_process
    end

    it 'errors out if the login fails' do
      expect_any_instance_of(ILO_SDK::Client).to receive(:rest_get).with('/redfish/v1/Sessions/')
        .and_return(FakeResponse.new({}, 401))
      expect($stderr).to receive(:puts).with(/Unauthorized/i)
      expect { command }.to raise_error SystemExit
    end
  end
end
