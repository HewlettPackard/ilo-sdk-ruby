require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'
  
  describe '#get_power_state' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('PowerState' => 'On')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      power_state = @client.get_power_state
      expect(power_state).to eq('On')
    end
  end

  describe '#set_power_state' do
    it 'makes a POST rest call' do
      new_action = {'Action' => 'Reset', 'ResetType' => 'ForceRestart'}
      expect(@client).to receive(:rest_post).with('/redfish/v1/Systems/1/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_power_state('ForceRestart')
      expect(ret_val).to eq(true)
    end
  end

  describe '#reset_ilo' do
    it 'makes a POST rest call' do
      new_action = {'Action' => 'Reset'}
      expect(@client).to receive(:rest_post).with('/redfish/v1/Managers/1/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.reset_ilo
      expect(ret_val).to eq(true)
    end
  end
end
