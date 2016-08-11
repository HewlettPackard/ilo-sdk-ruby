require_relative './../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  let(:path) { '/redfish/v1/fake' }
  let(:data) { { 'name' => 'Fake', 'description' => 'Fake Resource', 'uri' => path } }

  describe '#rest_api' do
    before :each do
      fake_response = FakeResponse.new({ name: 'New' }, 200, location: path)
      allow_any_instance_of(Net::HTTP).to receive(:request).and_return(fake_response)
    end

    it 'requires a path' do
      expect { @client.rest_api(:get, nil) }.to raise_error(ILO_SDK::InvalidRequest, /Must specify path/)
    end

    it 'logs the request type and path (debug level)' do
      @client.logger.level = @client.logger.class.const_get('DEBUG')
      %w(get post put patch delete).each do |type|
        expect { @client.rest_api(type, path) }
          .to output(/Making :#{type} rest call to #{@client.host + path}/).to_stdout_from_any_process
      end
    end

    it 'respects the disable_proxy client option' do
      @client.disable_proxy = true
      expect(Net::HTTP).to receive(:new).with(anything, anything, nil, nil).and_raise('Fake Error')
      expect { @client.rest_api(:get, path) }.to raise_error('Fake Error')
    end
    
    it 'does not disable the proxy unless the disable_proxy client option is set' do
      expect(Net::HTTP).to receive(:new).with(anything, anything).and_raise('Fake Error')
      expect { @client.rest_api(:get, path) }.to raise_error('Fake Error')
    end

    it 'raises an error when the ssl validation fails' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(OpenSSL::SSL::SSLError, 'Msg')
      expect(@client.logger).to receive(:error).with(/SSL verification failed/)
      expect { @client.rest_api(:get, path) }.to raise_error(OpenSSL::SSL::SSLError)
    end
  end

  describe '#rest_get' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:get, path, {})
      @client.rest_get(path)
    end
  end

  describe '#rest_post' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:post, path, body: data)
      @client.rest_post(path, body: data)
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:post, path, {})
      @client.rest_post(path)
    end
  end

  describe '#rest_put' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:put, path, {})
      @client.rest_put(path, {})
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:put, path, {})
      @client.rest_put(path)
    end
  end

  describe '#rest_patch' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:patch, path, {})
      @client.rest_patch(path, {})
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:patch, path, {})
      @client.rest_patch(path)
    end
  end

  describe '#rest_delete' do
    it 'calls rest_api' do
      expect(@client).to receive(:rest_api).with(:delete, path, {})
      @client.rest_delete(path, {})
    end

    it 'has default options and api_ver' do
      expect(@client).to receive(:rest_api).with(:delete, path, {})
      @client.rest_delete(path)
    end
  end

  describe '#response_handler' do
    it 'returns the JSON-parsed body for 200 status' do
      expect(@client.response_handler(FakeResponse.new(data))).to eq(data)
    end

    it 'returns the JSON-parsed body for 201 status' do
      expect(@client.response_handler(FakeResponse.new(data, 201))).to eq(data)
    end

    # it 'waits on the task completion for 202 status' do
    # initial_response = FakeResponse.new(data, 202, 'location' => '/rest/task/fake')
    # wait_response = FakeResponse.new({}, 200, 'associatedResource' => { 'resourceUri' => data['uri'] })
    # expect(@client).to receive(:wait_for).with('/rest/task/fake').and_return(wait_response)
    # expect(@client).to receive(:rest_get).with(data['uri']).and_return(FakeResponse.new(data))
    # expect(@client.response_handler(initial_response)).to eq(data)
    # end

    # it 'allows you to set wait_for_task to false' do
    # response = FakeResponse.new(data, 202, 'location' => '/rest/task/fake')
    # expect(@client.response_handler(response, false)).to eq(data)
    # end

    it 'returns an empty hash for 204 status' do
      expect(@client.response_handler(FakeResponse.new({}, 204))).to eq({})
    end

    it 'raises an error for 400 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 400)
      expect { @client.response_handler(resp) }.to raise_error(ILO_SDK::BadRequest, /400 BAD REQUEST.*Blah/)
    end

    it 'raises an error for 401 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 401)
      expect { @client.response_handler(resp) }.to raise_error(ILO_SDK::Unauthorized, /401 UNAUTHORIZED.*Blah/)
    end

    it 'raises an error for 404 status' do
      resp = FakeResponse.new({ message: 'Blah' }, 404)
      expect { @client.response_handler(resp) }.to raise_error(ILO_SDK::NotFound, /404 NOT FOUND.*Blah/)
    end

    it 'raises an error for undefined status codes' do
      [0, 19, 199, 203, 399, 402, 500].each do |status|
        resp = FakeResponse.new({ message: 'Blah' }, status)
        expect { @client.response_handler(resp) }.to raise_error(ILO_SDK::RequestError, /#{status}.*Blah/)
      end
    end
  end

  describe '#build_request' do
    before :each do
      @uri = URI.parse(URI.escape(@client.host + path))
    end

    it 'fails when an invalid request type is given' do
      expect { @client.send(:build_request, :fake, @uri, {}) }.to raise_error(/Invalid rest call/)
    end

    context 'default header values' do
      before :each do
        @req = @client.send(:build_request, :get, @uri, {})
      end

      it 'sets the basic_auth values' do
        expect(@req['authorization']).to match(/Basic/)
      end

      it 'sets the Content-Type' do
        expect(@req['Content-Type']).to eq('application/json')
      end
    end

    it 'allows deletion of default headers' do
      options = { 'Content-Type' => :none, 'auth' => 'none' }
      req = @client.send(:build_request, :get, @uri, options)
      expect(req['Content-Type']).to eq(nil)
      expect(req['authorization']).to eq(nil)
    end

    it 'allows additional headers to be set' do
      options = { 'My-Header' => 'blah' }
      req = @client.send(:build_request, :get, @uri, options)
      expect(req['My-Header']).to eq('blah')
    end

    it 'sets the body option to the request body' do
      options = { 'body' => { name: 'New', uri: path } }
      req = @client.send(:build_request, :get, @uri, options)
      expect(req.body).to eq(options['body'].to_json)
    end

    it 'logs the filtered request options (debug level)' do
      body = { 'key1' => 'val1' }
      expected_options = { 'body' => body, 'Content-Type' => 'application/json' }
      @client.logger.level = @client.logger.class.const_get('DEBUG')
      expect { @client.send(:build_request, :post, @uri, 'body' => body) }
        .to output(/Options: #{expected_options}/).to_stdout_from_any_process
    end
  end
end
