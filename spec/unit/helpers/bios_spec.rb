require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  #describe '#get_asset_tag' do
  #  it 'makes a GET rest call' do
  #    fake_response = FakeResponse.new('AssetTag' => 'HP001')
  #    expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
  #    state = @client.get_asset_tag
  #    expect(state).to eq('HP001')
  #  end
  #end

  #describe '#set_asset_tag' do
  #  it 'makes a PATCH rest call' do
  #    options = { 'AssetTag' => 'HP002' }
  #    expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: options).and_return(FakeResponse.new)
  #    ret_val = @client.set_asset_tag('HP002')
  #    expect(ret_val).to eq(true)
  #  end
  #end

  describe '#get_bios_baseconfig' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('BaseConfig' => 'default')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Boot/Settings/').and_return(fake_response)
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
end
