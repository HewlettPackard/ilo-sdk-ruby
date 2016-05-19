require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_boot_baseconfig' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('BaseConfig' => 'default')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/bios/Boot/Settings/').and_return(fake_response)
      base_config = @client.get_boot_baseconfig
      expect(base_config).to eq('default')
    end
  end

  describe '#revert_boot' do
    it 'makes a PATCH rest call' do
      new_action = {'BaseConfig' => 'default'}
      expect(@client).to receive(:rest_patch).with('/redfish/v1/systems/1/bios/Boot/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.revert_boot
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_boot_order' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('PersistentBootConfigOrder' => 'PersistentBootConfigOrder')
      expect(@client).to receive(:rest_get).with('/redfish/v1/systems/1/bios/Boot/Settings/').and_return(fake_response)
      boot_order = @client.get_boot_order
      expect(boot_order).to eq('PersistentBootConfigOrder')
    end
  end

  describe '#set_boot_order' do
    it 'makes a PATCH rest call' do
      new_action = {'PersistentBootConfigOrder' => 'PersistentBootConfigOrder'}
      expect(@client).to receive(:rest_patch).with('/redfish/v1/systems/1/bios/Boot/Settings/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_boot_order('PersistentBootConfigOrder')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_temporary_boot_order' do
    it 'makes a GET rest call' do
      body = {
        'Boot' => {
          'BootSourceOverrideTarget' => 'BootSourceOverrideTarget'
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      temporary_boot_order = @client.get_temporary_boot_order
      expect(temporary_boot_order).to eq('BootSourceOverrideTarget')
    end
  end

  describe '#set_temporary_boot_order' do
    it 'makes a PATCH rest call' do
      new_action = {
        'Boot' => {
          'BootSourceOverrideTarget' => '1'
        }
      }
      body = {
        'Boot' => {
          'BootSourceOverrideSupported' => ['1', '2', '3']
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_temporary_boot_order('1')
      expect(ret_val).to eq(true)
    end
  end
end
