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
      expect(client.disable_proxy).to eq(nil)
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
      expect_any_instance_of(Logger).to receive(:warn).with(/SSL is disabled/).and_return(true)
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123', ssl_enabled: false }
      client = described_class.new(options)
      expect(client.ssl_enabled).to eq(false)
    end

    it 'does not allow invalid ssl_enabled attributes' do
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123', ssl_enabled: 'bad' }
      expect { described_class.new(options) }.to raise_error(ILO_SDK::InvalidClient, /must be true or false/)
    end

    it 'allows the disable_proxy attribute to be set' do
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123', disable_proxy: true }
      client = described_class.new(options)
      expect(client.disable_proxy).to eq(true)
    end

    it 'allows the log level to be set' do
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123', log_level: :error }
      client = described_class.new(options)
      expect(client.log_level).to eq(:error)
    end

    it 'respects environment variables' do
      ENV['ILO_HOST'] = 'ilo.example.com'
      ENV['ILO_USER'] = 'Admin'
      ENV['ILO_PASSWORD'] = 'secret456'
      ENV['ILO_SSL_ENABLED'] = 'false'
      expect_any_instance_of(Logger).to receive(:warn).with(/SSL is disabled/).and_return(true)
      client = described_class.new
      expect(client.host).to eq('https://ilo.example.com')
      expect(client.user).to eq('Admin')
      expect(client.password).to eq('secret456')
      expect(client.ssl_enabled).to eq(false)
      ENV['ILO_SSL_ENABLED'] = 'true'
      client = described_class.new
      expect(client.ssl_enabled).to eq(true)
    end

    it 'does not allow invalid ssl_enabled attributes set as an environment variable' do
      ENV['ILO_SSL_ENABLED'] = 'bad'
      options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123' }
      expect { described_class.new(options) }.to raise_error(ILO_SDK::InvalidClient, /must be true or false/)
    end
  end
end
