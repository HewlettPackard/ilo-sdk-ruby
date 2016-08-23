require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  let(:settings) do
    { 'key1' => 'val1', 'key2' => 'val2', 'key3' => 'val3' }
  end

  describe '#get_system_settings' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new(settings)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      expect(@client.get_system_settings).to eq(settings)
    end

    it 'allows the system_id to be set' do
      fake_response = FakeResponse.new(settings)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/3/').and_return(fake_response)
      expect(@client.get_system_settings(3)).to eq(settings)
    end
  end

  describe '#set_system_settings' do
    it 'makes a PATCH rest call' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: settings).and_return(FakeResponse.new)
      expect(@client.set_system_settings(settings)).to eq(true)
    end

    it 'allows the system_id to be set' do
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/3/', body: settings).and_return(FakeResponse.new)
      @client.set_system_settings(settings, 3)
    end
  end

  describe '#get_asset_tag' do
    it 'makes a GET rest call' do
      expect(@client.logger).to receive(:warn).with(/Deprecated/).and_return(true)
      fake_response = FakeResponse.new('AssetTag' => 'HP001')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      state = @client.get_asset_tag
      expect(state).to eq('HP001')
    end
  end

  describe '#set_asset_tag' do
    it 'makes a PATCH rest call' do
      expect(@client.logger).to receive(:warn).with(/Deprecated/).and_return(true)
      options = { 'AssetTag' => 'HP002' }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: options).and_return(FakeResponse.new)
      ret_val = @client.set_asset_tag('HP002')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_indicator_led' do
    it 'makes a GET rest call' do
      expect(@client.logger).to receive(:warn).with(/Deprecated/).and_return(true)
      fake_response = FakeResponse.new('IndicatorLED' => 'Off')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      state = @client.get_indicator_led
      expect(state).to eq('Off')
    end
  end

  describe '#set_indicator_led' do
    it 'makes a PATCH rest call' do
      expect(@client.logger).to receive(:warn).with(/Deprecated/).and_return(true)
      options = { 'IndicatorLED' => :Lit }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: options).and_return(FakeResponse.new)
      ret_val = @client.set_indicator_led(:Lit)
      expect(ret_val).to eq(true)
    end
  end
end
