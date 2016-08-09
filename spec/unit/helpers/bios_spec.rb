require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_bios_settings' do
    it 'makes a GET rest call' do
      body = {
        'BaseConfig' => 'default',
        'UefiShellStartup' => 'UefiShellStartup',
        'UefiShellStartupLocation' => 'UefiShellStartupLocation',
        'UefiShellStartupUrl' => 'UefiShellStartupUrl',
        'Dhcpv4' => 'Enabled',
        'Ipv4Address' => '0.0.0.0',
        'Ipv4Gateway' => '0.0.0.0',
        'Ipv4PrimaryDNS' => '0.0.0.0',
        'Ipv4SecondaryDNS' => '0.0.0.0',
        'Ipv4SubnetMask' => '0.0.0.0',
        'ServiceName' => 'John Doe',
        'ServiceEmail' => 'john.doe@hpe.com'
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Settings/').and_return(fake_response)
      bios = @client.get_bios_settings
      expect(bios).to eq(body)
    end

    it 'makes a GET rest call' do
      body = {
        'BaseConfig' => 'default',
        'UefiShellStartup' => 'UefiShellStartup',
        'UefiShellStartupLocation' => 'UefiShellStartupLocation',
        'UefiShellStartupUrl' => 'UefiShellStartupUrl',
        'Dhcpv4' => 'Enabled',
        'Ipv4Address' => '0.0.0.0',
        'Ipv4Gateway' => '0.0.0.0',
        'Ipv4PrimaryDNS' => '0.0.0.0',
        'Ipv4SecondaryDNS' => '0.0.0.0',
        'Ipv4SubnetMask' => '0.0.0.0',
        'ServiceName' => 'John Doe',
        'ServiceEmail' => 'john.doe@hpe.com'
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Settings/').and_return(fake_response)
      bios = @client.get_bios_settings(%w(UefiShellStartup UefiShellStartupLocation UefiShellStartupUrl))
      expect(bios).to eq(
        'UefiShellStartup' => 'UefiShellStartup',
        'UefiShellStartupLocation' => 'UefiShellStartupLocation',
        'UefiShellStartupUrl' => 'UefiShellStartupUrl'
      )
    end
  end

  describe '#revert_bios' do
    it 'makes a PATCH rest call' do
      new_action = { 'BaseConfig' => 'default' }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/bios/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.revert_bios
      expect(ret_val).to eq(true)
    end
  end

  describe '#set_bios_settings' do
    it 'makes a PATCH rest call' do
      bios_settings = {
        'ServiceName' => 'John Doe',
        'ServiceEmail' => 'john.doe@hpe.com'
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/bios/Settings/', body: bios_settings).and_return(FakeResponse.new)
      ret_val = @client.set_bios_settings(bios_settings)
      expect(ret_val).to eq(true)
    end
  end
end
