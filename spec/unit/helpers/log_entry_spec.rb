require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#clear_logs' do
    it 'makes a POST rest call' do
      log_type = 'IEL'
      new_action = {'Action' => 'ClearLog'}
      expect(@client).to receive(:rest_post).with("/redfish/v1/Managers/1/LogServices/#{log_type}/", body: new_action).and_return(FakeResponse.new)
      ret_val = @client.clear_logs(log_type)
      expect(ret_val).to eq(true)
    end
  end

  describe '#logs_empty?' do
    log_type = 'IEL'
    it 'makes a GET rest call' do
      body = {
        'Items' => [
          {
            'it' => 1
          },
          {
            'it' => 2
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/").and_return(fake_response)
      ret_val = @client.logs_empty?(log_type)
      expect(ret_val).to eq(false)
    end
  end

  describe '#get_logs' do
    it 'makes a GET rest call' do
      severity_level = 'OK'
      duration = 10 #NOTE: may need to increase this for tests in the future.
      log_type = 'IEL'
      now = Time.now.utc
      body = {
        'Items' => [
          {
            'Severity' => 'OK',
            'Message' => 'First IEL Log',
            'Created' => now - (duration * 3600) + 1 # Falls in time range
          },
          {
            'Severity' => 'OK',
            'Message' => 'Second IEL Log',
            'Created' => now - (duration * 3600) + 1
          },
          {
            'Severity' => 'OK',
            'Message' => 'Third IEL Log',
            'Created' => now - (duration * 3600)
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/").and_return(fake_response)
      log_entries = @client.get_logs(severity_level, duration, log_type)
      expect(log_entries).to eq(["OK | First IEL Log | #{now - (duration * 3600) + 1}", "OK | Second IEL Log | #{now - (duration * 3600) + 1}"])
    end
  end
end
