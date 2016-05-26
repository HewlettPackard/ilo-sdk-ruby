require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_schema' do
    it 'makes a GET rest call' do
      body = {
        'Items' => [
          {
            'Schema' => 'AccountService.1.0.0',
            'Location' => [
              {
                'Uri' => {
                  'extref' => '/redfish/v1/SchemaStore/en/AccountService.json/'
                }
              }
            ]
          },
          {
            'Schema' => 'BaseNetworkAdapter.1.1.0',
            'Location' => [
              {
                'Uri' => {
                  'extref' => '/redfish/v1/SchemaStore/en/BaseNetworkAdapter.json/'
                }
              }
            ]
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Schemas/').and_return(fake_response)
      body = {
        'title' => 'AccountService.1.0.0'
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/SchemaStore/en/AccountService.json/').and_return(fake_response)
      schema = @client.get_schema('AccountService')
      expect(schema).to eq(['title' => 'AccountService.1.0.0'])
    end
  end

  describe '#get_registry' do
    it 'makes a GET rest call' do
      body = {
        'Items' => [
          {
            'Schema' => 'Base.0.10.0',
            'Location' => [
              {
                'Uri' => {
                  'extref' => '/redfish/v1/RegistryStore/registries/en/Base.json/'
                }
              }
            ]
          },
          {
            'Schema' => 'HpCommon.0.10.0',
            'Location' => [
              {
                'Uri' => {
                  'extref' => '/redfish/v1/RegistryStore/registries/en/HpCommon.json/'
                }
              }
            ]
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Registries/').and_return(fake_response)
      body = {
        'Name' => 'Base Message Registry'
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/RegistryStore/registries/en/Base.json/').and_return(fake_response)
      registry = @client.get_registry('Base')
      expect(registry).to eq(['Name' => 'Base Message Registry'])
    end
  end
end
