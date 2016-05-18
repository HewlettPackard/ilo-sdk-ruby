require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_time_zone' do
    it 'makes a GET rest call' do
      body = {
        'TimeZone' => {
          'Name' => 'Africa/Azerbaijan'
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/DateTime/').and_return(fake_response)
      time_zone = @client.get_time_zone
      expect(time_zone).to eq('Africa/Azerbaijan')
    end
  end

  describe '#set_time_zone' do
    it 'makes a GET and PATCH rest call' do
      body = {
        'TimeZoneList' => [
          {
            'Index' => 0,
            'Name' => 'Africa/Azerbaijan'
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/DateTime/').and_return(fake_response)
      new_action = {
        'TimeZone' => {
          'Index' => 0
        }
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/DateTime/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_time_zone('Africa/Azerbaijan')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_ntp' do
    it 'makes a GET rest call' do
      body = {
        'Oem' => {
          'Hp' => {
            'DHCPv4' => {
              'UseNTPServers' => false
            }
          }
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/EthernetInterfaces/1/').and_return(fake_response)
      ntp = @client.get_ntp
      expect(ntp).to eq(false)
    end
  end

  describe '#set_ntp' do
    it 'makes a PATCH rest call' do
      new_action = {
        'Oem' => {
          'Hp' => {
            'DHCPv4' => {
              'UseNTPServers' => true
            }
          }
        }
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/EthernetInterfaces/1/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_ntp(true)
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_ntp_servers' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('StaticNTPServers' => '')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/DateTime/').and_return(fake_response)
      ntp_servers = @client.get_ntp_servers
      expect(ntp_servers).to eq('')
    end
  end

  describe '#set_ntp_servers' do
    it 'makes a SET rest call' do
      new_action = {'StaticNTPServers' => ''}
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/DateTime/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_ntp_servers('')
      expect(ret_val).to eq(true)
    end
  end
end
