require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_asset_tag' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('AssetTag' => 'HP001')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      state = @client.get_asset_tag
      expect(state).to eq('HP001')
    end
  end

  describe '#set_asset_tag' do
    it 'makes a PATCH rest call' do
      options = { 'AssetTag' => 'HP002' }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: options).and_return(FakeResponse.new)
      ret_val = @client.set_asset_tag('HP002')
      expect(ret_val).to eq(true)
    end
  end
end
