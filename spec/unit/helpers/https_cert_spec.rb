require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  # def get_certificate
  #   uri = URI.parse(URI.escape(@host))
  #   options = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  #   x509 = Net::HTTP.start(uri.host, uri.port, options) do |http|
  #     http.peer_cert
  #   end
  #   x509.to_text
  # end
  describe '#get_certificate' do
    it 'it makes an HTTP call' do
      #expect(URI).to receive(:parse).with(URI.escape(@client.host))
    end
  end

  describe '#import_certificate' do
    it 'makes a POST rest call' do
      certificate = '-----BEGIN CERTIFICATE-----
      skjfhsjkhjhsgdjkhsjdewrhghkjshgsdfghsdfkjhsdk
      -----END CERTIFICATE-----'
      new_action = {
        'Action' => 'ImportCertificate',
        'Certificate' => certificate
      }
      expect(@client).to receive(:rest_post).with('/redfish/v1/Managers/1/SecurityService/HttpsCert/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.import_certificate(certificate)
      expect(ret_val).to eq(true)
    end
  end

  describe '#generate_csr' do
    it 'makes a POST rest call' do
      new_action = {
        'Action' => 'GenerateCSR',
        'Country' => 'US',
        'State' => 'Texas',
        'City' => 'Houston',
        'OrgName' => 'Hewlett Packard Enterprise Company',
        'OrgUnit' => 'ISS',
        'CommonName' => 'ILO123.americas.hpqcorp.net'
      }
      expect(@client).to receive(:rest_post).with('/redfish/v1/Managers/1/SecurityService/HttpsCert/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.generate_csr('US', 'Texas', 'Houston', 'Hewlett Packard Enterprise Company', 'ISS', 'ILO123.americas.hpqcorp.net')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_csr' do
    it 'makes a GET rest call' do
      certificateSigningRequest = '-----BEGIN CERTIFICATE REQUEST-----
      MIIDJzCCAg8CAQAwgZAxJDAiBgNVBAMMG0lMTzEyMy5hbWVyaWNhcy5ocHFjb3Jw
      -----END CERTIFICATE REQUEST-----'
      body = {
        'CertificateSigningRequest' => certificateSigningRequest
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Managers/1/SecurityService/HttpsCert/').and_return(fake_response)
      csr = @client.get_csr
      expect(csr).to eq(certificateSigningRequest)
    end
  end
end
