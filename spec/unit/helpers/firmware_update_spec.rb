require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_fw_version' do
    it 'makes a GET rest call' do
      body = {
        'Current' => {
          'SystemBMC' => [
            {
              'VersionString' => 2.5
            }
          ]
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/FirmWareInventory/').and_return(fake_response)
      fw_version = @client.get_fw_version
      expect(fw_version).to eq(2.5)
    end
  end

  describe 'set_fw_upgrade' do
    it 'makes a POST rest call' do
      new_action = {
        'Action' => 'InstallFromURI',
        'FirmwareURI' => 'www.testuri.com',
        'TPMOverrideFlag' => true
      }
      expect(@client).to receive(:rest_post).with('/redfish/v1/Managers/1/UpdateService/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_fw_upgrade('www.testuri.com')
      expect(ret_val).to eq(true)
    end
  end
end
