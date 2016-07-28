# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

module ILO_SDK
  # Contains helper methods for HTTPS Certificates
  module HttpsCertHelper
    # Get the SSL Certificate
    # @raise [RuntimeError] if the request failed
    # @return [String] x509_certificate
    def get_certificate
      uri = URI.parse(URI.escape(@host))
      options = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
      Net::HTTP.start(uri.host, uri.port, options) do |http|
        http.peer_cert.to_pem
      end
    end

    # Import the x509 certificate
    # @param [String] certificate
    # @raise [RuntimeError] if the request failed
    # @return true
    def import_certificate(certificate)
      new_action = {
        'Action' => 'ImportCertificate',
        'Certificate' => certificate
      }
      response = rest_post('/redfish/v1/Managers/1/SecurityService/HttpsCert/', body: new_action)
      response_handler(response)
      true
    end

    # Generate a Certificate Signing Request
    # @param [String] country
    # @param [String] state
    # @param [String] city
    # @param [String] orgName
    # @param [String] orgUnit
    # @param [String] commonName
    # @raise [RuntimeError] if the request failed
    # @return true
    def generate_csr(country, state, city, org_name, org_unit, common_name)
      new_action = {
        'Action' => 'GenerateCSR',
        'Country' => country,
        'State' => state,
        'City' => city,
        'OrgName' => org_name,
        'OrgUnit' => org_unit,
        'CommonName' => common_name
      }
      response = rest_post('/redfish/v1/Managers/1/SecurityService/HttpsCert/', body: new_action)
      response_handler(response)
      true
    end

    # Get the Certificate Signing Request
    # @raise [RuntimeError] if the request failed
    # @return [String] certificate_signing_request
    def get_csr
      response = rest_get('/redfish/v1/Managers/1/SecurityService/HttpsCert/')
      response_handler(response)['CertificateSigningRequest']
    end
  end
end
