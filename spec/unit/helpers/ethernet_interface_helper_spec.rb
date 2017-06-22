require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_ilo_ethernet_interface' do
    before(:all) do
      @settings = { 'key1' => 'val1', 'key2' => 'val2', 'key3' => 'val3' }
    end

    it 'makes a GET rest call' do
      fake_response = FakeResponse.new(@settings)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/EthernetInterfaces/1/').and_return(fake_response)
      expect(@client.get_ilo_ethernet_interface).to eq(@settings)
    end

    it 'allows the system_id to be set' do
      fake_response = FakeResponse.new(@settings)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/2/EthernetInterfaces/1/').and_return(fake_response)
      expect(@client.get_ilo_ethernet_interface(2)).to eq(@settings)
    end

    it 'allows system_id and ethernet_interface to be set' do
      fake_response = FakeResponse.new(@settings)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/2/EthernetInterfaces/2/').and_return(fake_response)
      expect(@client.get_ilo_ethernet_interface(2, 2)).to eq(@settings)
    end

  end

  describe '#set_ilo_dhcp' do
    before(:all) do
      @enable_dhcp_body = {
        'Oem' => {
          'Hp' => {
            'DHCPv4' => {
              'Enabled' => true,
              'UseDNSServers' => true,
              'UseDomainName' => true,
              'UseGateway' => true,
              'UseNTPServers' => true,
              'UseStaticRoutes' => true,
              'UseWINSServers' => true
            }
          }
        }
      }
    end

    it 'makes a PATCH rest call' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/EthernetInterfaces/1/', body: @enable_dhcp_body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_dhcp).to eq(true)
    end

    it 'allows the system_id to be set' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/2/EthernetInterfaces/1/', body: @enable_dhcp_body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_dhcp(2)).to eq(true)
    end

    it 'allows system_id and ethernet_interface to be set' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/2/EthernetInterfaces/2/', body: @enable_dhcp_body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_dhcp(2, 2)).to eq(true)
    end
  end

  describe '#set_ilo_ipv4_static' do
    before(:all) do
      @body = {
        'Oem' => { 'Hp' => { 'DHCPv4' => { 'Enabled' => false } } },
        'IPv4Addresses' => ['Address' => '192.168.1.1', 'SubnetMask' => '255.255.255.0', 'Gateway' => '0.0.0.0']
      }
    end

    it 'makes a PATCH rest call' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/EthernetInterfaces/1/', body: @body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_static('192.168.1.1', '255.255.255.0')).to eq(true)
    end

    it 'allows the gateway to be set' do
      body = Marshal.load(Marshal.dump(@body))
      body['IPv4Addresses'][0]['Gateway'] = '192.168.1.254'
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/EthernetInterfaces/1/', body: body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_static('192.168.1.1', '255.255.255.0', '192.168.1.254')).to eq(true)
    end

    it 'allows the system_id to be set' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/2/EthernetInterfaces/1/', body: @body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_static('192.168.1.1', '255.255.255.0', '0.0.0.0', 2)).to eq(true)
    end

    it 'allows system_id and ethernet_interface to be set' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/2/EthernetInterfaces/2/', body: @body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_static('192.168.1.1', '255.255.255.0', '0.0.0.0', 2, 2)).to eq(true)
    end
  end

  describe '#set_ilo_ipv4_dns_servers' do
    before(:all) do
      @dns_servers = ['2.2.2.2', '4.4.4.4', '8.8.8.8']
      @body = { 'Oem' => { 'Hp' => { 'DHCPv4' => { 'UseDNSServers' => false }, 'IPv4' => { 'DNSServers' => @dns_servers } } } }
    end

    it 'makes a PATCH rest call' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/1/EthernetInterfaces/1/', body: @body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_dns_servers(@dns_servers)).to eq(true)
    end

    it 'allows the system_id to be set' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/2/EthernetInterfaces/1/', body: @body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_dns_servers(@dns_servers, 2)).to eq(true)
    end

    it 'allows system_id and ethernet_interface to be set' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Managers/2/EthernetInterfaces/2/', body: @body).and_return(FakeResponse.new)
      expect(@client.set_ilo_ipv4_dns_servers(@dns_servers, 2, 2)).to eq(true)
    end
  end
end
