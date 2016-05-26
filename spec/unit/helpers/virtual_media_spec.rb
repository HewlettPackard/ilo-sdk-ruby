require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_virtual_media' do
    it 'makes a GET rest call' do
      body = {
        'links' => {
          'Member' => [
            {
              'href' => '/redfish/v1/Managers/1/VirtualMedia/1/'
            },
            {
              'href' => '/redfish/v1/Managers/1/VirtualMedia/2/'
            }
          ]
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/VirtualMedia/').and_return(fake_response)
      body = {
        'Id' => '1',
        'Image' => '',
        'MediaTypes' => %w(Floppy USBStick)
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/VirtualMedia/1/').and_return(fake_response)
      body = {
        'Id' => '2',
        'Image' => '',
        'MediaTypes' => %w(CD DVD)
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/VirtualMedia/2/').and_return(fake_response)
      media = @client.get_virtual_media
      expect(media).to eq(
        '1' => {
          'Image' => '',
          'MediaTypes' => %w(Floppy USBStick)
        },
        '2' => {
          'Image' => '',
          'MediaTypes' => %w(CD DVD)
        }
      )
    end
  end

  describe '#virtual_media_inserted?' do
    it 'makes a GET rest call' do
      id = 1
      fake_response = FakeResponse.new('Inserted' => true)
      expect(@client).to receive(:rest_get).with("/redfish/v1/Managers/1/VirtualMedia/#{id}/").and_return(fake_response)
      media_inserted = @client.virtual_media_inserted?(id)
      expect(media_inserted).to eq(true)
    end
  end

  describe '#insert_virtual_media' do
    it 'makes a POST rest call' do
      id = 1
      image = ''
      new_action = {
        'Action' => 'InsertVirtualMedia',
        'Target' => '/Oem/Hp',
        'Image' => image
      }
      expect(@client).to receive(:rest_post).with("/redfish/v1/Managers/1/VirtualMedia/#{id}/", body: new_action).and_return(FakeResponse.new)
      ret_val = @client.insert_virtual_media(id, image)
      expect(ret_val).to eq(true)
    end
  end

  describe '#eject_virtual_media' do
    it 'makes a POST rest call' do
      id = 1
      new_action = {
        'Action' => 'EjectVirtualMedia',
        'Target' => '/Oem/Hp'
      }
      expect(@client).to receive(:rest_post).with("/redfish/v1/Managers/1/VirtualMedia/#{id}/", body: new_action).and_return(FakeResponse.new)
      ret_val = @client.eject_virtual_media(id)
      expect(ret_val).to eq(true)
    end
  end
end
