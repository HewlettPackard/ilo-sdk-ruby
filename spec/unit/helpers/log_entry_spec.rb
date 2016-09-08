require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#uri_for_log_type' do
    it 'gets the IEL logs URI' do
      expect(@client.uri_for_log_type('IEL')).to eq('/redfish/v1/Managers/1/LogServices/IEL/')
    end

    it 'gets the IML logs URI' do
      expect(@client.uri_for_log_type('IML')).to eq('/redfish/v1/Systems/1/LogServices/IML/')
    end

    it 'converts the type to upcase' do
      expect(@client.uri_for_log_type('iml')).to eq('/redfish/v1/Systems/1/LogServices/IML/')
    end

    it 'allows you to pass in a resource ID' do
      expect(@client.uri_for_log_type('IML', 2)).to eq('/redfish/v1/Systems/2/LogServices/IML/')
    end

    it 'fails for invalid resource types' do
      expect { @client.uri_for_log_type('Fake') }.to raise_error(/Invalid log_type/)
    end
  end

  describe '#clear_logs' do
    let(:new_action) { { 'Action' => 'ClearLog' } }

    it 'makes a POST rest call for IEL logs' do
      log_type = 'IEL'
      expect(@client).to receive(:rest_post).with("/redfish/v1/Managers/1/LogServices/#{log_type}/", body: new_action)
        .and_return(FakeResponse.new)
      ret_val = @client.clear_logs(log_type)
      expect(ret_val).to eq(true)
    end

    it 'makes a POST rest call for IML logs' do
      log_type = 'IML'
      expect(@client).to receive(:rest_post).with("/redfish/v1/Systems/1/LogServices/#{log_type}/", body: new_action)
        .and_return(FakeResponse.new)
      ret_val = @client.clear_logs(log_type)
      expect(ret_val).to eq(true)
    end
  end

  describe '#logs_empty?' do
    before :each do
      body = {
        'Items' => [
          { 'it' => 1 },
          { 'it' => 2 }
        ]
      }
      @fake_response = FakeResponse.new(body)
    end

    it 'makes a GET rest call for IEL logs' do
      log_type = 'IEL'
      expect(@client).to receive(:rest_get).with("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/")
        .and_return(@fake_response)
      ret_val = @client.logs_empty?(log_type)
      expect(ret_val).to eq(false)
    end

    it 'makes a GET rest call for IML logs' do
      log_type = 'IML'
      expect(@client).to receive(:rest_get).with("/redfish/v1/Systems/1/LogServices/#{log_type}/Entries/")
        .and_return(@fake_response)
      ret_val = @client.logs_empty?(log_type)
      expect(ret_val).to eq(false)
    end
  end

  describe '#get_logs' do
    before :each do
      @duration = 10 # (hours)
      @now = Time.now.utc
      @entries = [
        {
          'Severity' => 'OK',
          'Message' => 'First IEL Log',
          'Created' => (@now - (@duration * 3600) + 2).to_s # In the time range
        },
        {
          'Severity' => 'OK',
          'Message' => 'Second IEL Log',
          'Created' => (@now - (@duration * 3600) + 1).to_s # In the time range
        },
        {
          'Severity' => 'OK',
          'Message' => 'Third IEL Log',
          'Created' => (@now - (@duration * 3600)).to_s # Outside the time range
        }
      ]
      @fake_response = FakeResponse.new('Items' => @entries)
    end

    it 'makes a GET rest call for IEL logs' do
      log_type = 'IEL'
      expect(@client).to receive(:rest_get).with("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/")
        .and_return(@fake_response)
      log_entries = @client.get_logs('OK', @duration, log_type)
      expect(log_entries).to eq([@entries[0], @entries[1]])
    end

    it 'makes a GET rest call for IML logs' do
      log_type = 'IML'
      expect(@client).to receive(:rest_get).with("/redfish/v1/Systems/1/LogServices/#{log_type}/Entries/")
        .and_return(@fake_response)
      log_entries = @client.get_logs(:ok, @duration, log_type)
      expect(log_entries).to eq([@entries[0], @entries[1]])
    end
  end
end
