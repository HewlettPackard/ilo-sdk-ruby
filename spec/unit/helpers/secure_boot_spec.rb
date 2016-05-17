require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_uefi_secure_boot' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('SecureBootEnable' => true)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/SecureBoot/').and_return(fake_response)
      secure_boot = @client.get_uefi_secure_boot
      expect(secure_boot).to eq(true)
    end
  end

  describe '#set_uefi_secure_boot' do
    it 'makes a PATCH rest call' do
      new_action = {'SecureBootEnable' => true}
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/SecureBoot/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_uefi_secure_boot(true)
      expect(ret_val).to eq(true)
    end
  end
end
