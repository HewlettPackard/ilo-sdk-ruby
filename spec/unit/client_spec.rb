require_relative './../spec_helper'

RSpec.describe ILO_SDK::Client do

  describe '#initialize' do
    it 'creates a client with valid credentials' do
      options = { host: 'https://ilo.example.com', user: 'Administrator', password: 'secret123' }
      client = described_class.new(options)
      expect(client.host).to eq('https://ilo.example.com')
      expect(client.user).to eq('Administrator')
      expect(client.password).to eq('secret123')
      expect(client.ssl_enabled).to eq(true)
      expect(client.log_level).to eq(:info)
      expect(client.logger).to be_a(Logger)
    end

    it 'requires the host attribute to be set' do
      expect { described_class.new({}) }.to raise_error(ILO_SDK::InvalidClient, /Must set the host option/)
    end

    it 'automatically prepends the host with "https://"' do
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123' }
      client = described_class.new(options)
      expect(client.host).to eq('https://ilo.example.com')
    end

    it 'requires the password attribute to be set' do
      options = { host: 'ilo.example.com', user: 'Administrator' }
      expect { described_class.new(options) }.to raise_error(ILO_SDK::InvalidClient, /Must set the password/)
    end

    it 'sets the username to "Administrator" by default' do
      options = { host: 'ilo.example.com', password: 'secret123' }
      client = nil
      expect { client = described_class.new(options) }.to output(/User option not set. Using default/).to_stdout_from_any_process
      expect(client.user).to eq('Administrator')
    end

    it 'allows the ssl_enabled attribute to be set' do
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123', ssl_enabled: false }
      client = described_class.new(options)
      expect(client.ssl_enabled).to eq(false)
    end

    it 'allows the log level to be set' do
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123', log_level: :error }
      client = described_class.new(options)
      expect(client.log_level).to eq(:error)
    end
  end
end
