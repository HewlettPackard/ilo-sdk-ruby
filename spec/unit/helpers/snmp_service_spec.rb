require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_snmp_mode' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('Mode' => 'Agentless')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/SnmpService/').and_return(fake_response)
      snmp_mode = @client.get_snmp_mode
      expect(snmp_mode).to eq('Agentless')
    end
  end

  describe '#get_snmp_alerts_enabled' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('AlertsEnabled' => false)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/SnmpService/').and_return(fake_response)
      snmp_alerts_enabled = @client.get_snmp_alerts_enabled
      expect(snmp_alerts_enabled).to eq(false)
    end
  end

  describe '#set_snmp' do
    it 'makes a PATCH rest call' do
      mode = 'Agentless'
      alerts_enabled = true
      new_action = { 'Mode' => mode, 'AlertsEnabled' => alerts_enabled }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/SnmpService/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_snmp(mode, alerts_enabled)
      expect(ret_val).to eq(true)
    end
  end
end
