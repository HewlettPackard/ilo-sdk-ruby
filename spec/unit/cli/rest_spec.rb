require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Cli do
  include_context 'cli context'

  let(:response) { { 'key1' => 'val1', 'key2' => 'val2', 'key3' => { 'key4' => 'val4' } } }

  describe '#rest get' do
    it 'requires a URI' do
      expect($stderr).to receive(:puts).with(/ERROR.*arguments/)
      ILO_SDK::Cli.start(%w(rest get))
    end

    it 'sends any data that is passed in' do
      data = { 'ServiceName' => 'iLO Admin', 'ServiceEmail' => 'admin@domain.com' }
      expect_any_instance_of(ILO_SDK::Client).to receive(:rest_api)
        .with('get', '/redfish/v1/', body: data).and_return FakeResponse.new(response)
      expect { ILO_SDK::Cli.start(['rest', 'get', 'redfish/v1/', '-d', data.to_json]) }
        .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
    end

    context 'output formats' do
      before :each do
        expect_any_instance_of(ILO_SDK::Client).to receive(:rest_api)
          .with('get', '/redfish/v1/', {}).and_return FakeResponse.new(response)
      end

      it 'makes a GET call to the URI and outputs the response in json format' do
        expect { ILO_SDK::Cli.start(%w(rest get redfish/v1/)) }
          .to output(JSON.pretty_generate(response) + "\n").to_stdout_from_any_process
      end

      it 'can output the response in raw format' do
        expect { ILO_SDK::Cli.start(%w(rest get redfish/v1/ -f raw)) }
          .to output(response.to_json + "\n").to_stdout_from_any_process
      end

      it 'can output the response in yaml format' do
        expect { ILO_SDK::Cli.start(%w(rest get redfish/v1/ -f yaml)) }
          .to output(response.to_yaml).to_stdout_from_any_process
      end
    end

    context 'bad requests' do
      it 'fails if the data cannot be parsed as json' do
        expect($stderr).to receive(:puts).with(/Failed to parse data as JSON/)
        expect { ILO_SDK::Cli.start(%w(rest get redfish/v1/ -d fake_json)) }
          .to raise_error SystemExit
      end

      it 'fails if the request method is invalid' do
        expect($stderr).to receive(:puts).with(/Invalid rest method/)
        expect { ILO_SDK::Cli.start(%w(rest blah redfish/v1/)) }
          .to raise_error SystemExit
      end

      it 'fails if the response code is 3XX' do
        headers = { 'location' => ['redfish/v1/Systems/1/'] }
        body = {}
        expect_any_instance_of(ILO_SDK::Client).to receive(:rest_api)
          .with('get', '/redfish/v1', {}).and_return FakeResponse.new(body, 308, headers)
        expect($stderr).to receive(:puts).with(/308.*location/m)
        expect { ILO_SDK::Cli.start(%w(rest get redfish/v1)) }
          .to raise_error SystemExit
      end

      it 'fails if the response code is 4XX' do
        headers = { 'content-type' => ['text/plain'] }
        body = { 'Message' => 'Not found!' }
        expect_any_instance_of(ILO_SDK::Client).to receive(:rest_api)
          .with('get', '/redfish/v1', {}).and_return FakeResponse.new(body, 404, headers)
        expect($stderr).to receive(:puts).with(/404.*content-type.*Not found/m)
        expect { ILO_SDK::Cli.start(%w(rest get redfish/v1)) }
          .to raise_error SystemExit
      end

      it 'fails if the response code is 4XX' do
        headers = { 'content-type' => ['text/plain'] }
        body = { 'Message' => 'Server error!' }
        expect_any_instance_of(ILO_SDK::Client).to receive(:rest_api)
          .with('get', '/redfish/v1', {}).and_return FakeResponse.new(body, 500, headers)
        expect($stderr).to receive(:puts).with(/500.*content-type.*Server error/m)
        expect { ILO_SDK::Cli.start(%w(rest get redfish/v1)) }
          .to raise_error SystemExit
      end
    end

  end
end
