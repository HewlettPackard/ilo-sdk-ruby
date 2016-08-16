require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Cli do
  include_context 'cli context'

  describe '#env' do
    let(:command) { ILO_SDK::Cli.start(['env']) }
    let(:data) { ILO_SDK::ENV_VARS.collect { |e| [e, ENV[e]] }.to_h }

    it 'shows ILO_HOST' do
      expect { command }.to output(%r{ILO_HOST\s+=\s'https:\/\/ilo\.example\.com'}).to_stdout_from_any_process
    end

    it 'shows ILO_USER' do
      expect { command }.to output(/ILO_USER\s+=\s'Admin'/).to_stdout_from_any_process
    end

    it 'shows ILO_PASSWORD' do
      ENV['ILO_PASSWORD'] = 'secret123'
      expect { command }.to output(/ILO_PASSWORD\s+=\s'secret123'/).to_stdout_from_any_process
    end

    it 'shows ILO_SSL_ENABLED as nil' do
      expect { command }.to output(/ILO_SSL_ENABLED\s+=\snil/).to_stdout_from_any_process
    end

    it 'shows ILO_SSL_ENABLED when set' do
      ENV['ILO_SSL_ENABLED'] = 'false'
      expect { command }.to output(/ILO_SSL_ENABLED\s+=\sfalse/).to_stdout_from_any_process
    end

    it 'prints the output in json format' do
      expect { ILO_SDK::Cli.start(%w(env -f json)) }.to output(JSON.pretty_generate(data) + "\n").to_stdout_from_any_process
    end

    it 'prints the output in yaml format' do
      expect { ILO_SDK::Cli.start(%w(env -f yaml)) }.to output(data.to_yaml).to_stdout_from_any_process
    end
  end
end
