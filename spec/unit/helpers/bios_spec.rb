require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_bios_baseconfig' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('BaseConfig' => 'default')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Settings/').and_return(fake_response)
      base_config = @client.get_bios_baseconfig
      expect(base_config).to eq('default')
    end
  end

  describe '#revert_bios' do
    it 'makes a PATCH rest call' do
      new_action = {'BaseConfig' => 'default'}
      expect(@client).to receive(:rest_patch).with('/redfish/v1/systems/1/bios/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.revert_bios
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_uefi_shell_startup' do
    it 'makes a GET rest call' do
      body = {
        'UefiShellStartup' => 'UefiShellStartup',
        'UefiShellStartupLocation' => 'UefiShellStartupLocation',
        'UefiShellStartupUrl' => 'UefiShellStartupUrl'
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Settings/').and_return(fake_response)
      uefi_shell_startup = @client.get_uefi_shell_startup
      expect(uefi_shell_startup).to eq(
        {
          'UefiShellStartup' => 'UefiShellStartup',
          'UefiShellStartupLocation' => 'UefiShellStartupLocation',
          'UefiShellStartupUrl' => 'UefiShellStartupUrl'
        }
      )
    end
  end

  describe '#set_uefi_shell_startup' do
    it 'makes a PATCH rest call' do
      new_action = {
        'UefiShellStartup' => 'uefi_shell_startup',
        'UefiShellStartupLocation' => 'uefi_shell_startup_location',
        'UefiShellStartupUrl' => 'uefi_shell_startup_url'
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/bios/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_uefi_shell_startup('uefi_shell_startup', 'uefi_shell_startup_location', 'uefi_shell_startup_url')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_bios_dhcp' do
    it 'makes a GET rest call' do
      body = {
        'Dhcpv4' => 'Enabled',
        'Ipv4Address' => '0.0.0.0',
        'Ipv4Gateway' => '0.0.0.0',
        'Ipv4PrimaryDNS' => '0.0.0.0',
        'Ipv4SecondaryDNS' => '0.0.0.0',
        'Ipv4SubnetMask' => '0.0.0.0'
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Settings/').and_return(fake_response)
      bios_dhcp = @client.get_bios_dhcp
      expect(bios_dhcp).to eq(
        {
          'Dhcpv4' => 'Enabled',
          'Ipv4Address' => '0.0.0.0',
          'Ipv4Gateway' => '0.0.0.0',
          'Ipv4PrimaryDNS' => '0.0.0.0',
          'Ipv4SecondaryDNS' => '0.0.0.0',
          'Ipv4SubnetMask' => '0.0.0.0'
        }
      )
    end
  end

  describe '#set_bios_dhcp' do
    it 'makes a PATCH rest call' do
      new_action = {
        'Dhcpv4' => 'Enabled',
        'Ipv4Address' => '0.0.0.0',
        'Ipv4Gateway' => '0.0.0.0',
        'Ipv4PrimaryDNS' => '0.0.0.0',
        'Ipv4SecondaryDNS' => '0.0.0.0',
        'Ipv4SubnetMask' => '0.0.0.0'
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/bios/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_bios_dhcp('Enabled', '0.0.0.0', '0.0.0.0', '0.0.0.0', '0.0.0.0', '0.0.0.0')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_url_boot_file' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('UrlBootFile' => 'http://wwww.urlbootfiletest.iso')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Settings/').and_return(fake_response)
      url_boot_file = @client.get_url_boot_file
      expect(url_boot_file).to eq('http://wwww.urlbootfiletest.iso')
    end
  end

  describe '#set_url_boot_file' do
    it 'makes a PATCH rest call' do
      new_action = {'UrlBootFile' => 'http://wwww.urlbootfiletest.iso'}
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/bios/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_url_boot_file('http://wwww.urlbootfiletest.iso')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_bios_service' do
    it 'makes a GET rest call' do
      body = {
        'ServiceName' => 'John Doe',
        'ServiceEmail' => 'john.doe@hpe.com'
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Settings/').and_return(fake_response)
      bios_service = @client.get_bios_service
      expect(bios_service).to eq(
        {
          'ServiceName' => 'John Doe',
          'ServiceEmail' => 'john.doe@hpe.com'
        }
      )
    end
  end

  describe '#set_bios_service' do
    it 'makes a PATCH rest call' do
      new_action = {
        'ServiceName' => 'John Doe',
        'ServiceEmail' => 'john.doe@hpe.com'
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/bios/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_bios_service('John Doe', 'john.doe@hpe.com')
      expect(ret_val).to eq(true)
    end
  end
end
