# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module ILO_SDK
  # Contains all the methods for making API REST calls
  module Rest
    # Make a restful API request to the iLO
    # @param [Symbol] type the rest method/type Options are :get, :post, :put, :patch, and :delete
    # @param [String] path the path for the request. Usually starts with "/rest/"
    # @param [Hash] options the options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @raise [InvalidRequest] if the request is invalid
    # @raise [SocketError] if a connection could not be made
    # @raise [OpenSSL::SSL::SSLError] if SSL validation of the iLO's certificate failed
    # @return [NetHTTPResponse] The response object
    def rest_api(type, path, options = {})
      raise InvalidRequest, 'Must specify path' unless path
      raise InvalidRequest, 'Must specify type' unless type
      @logger.debug "Making :#{type} rest call to #{@host}#{path}"

      uri = URI.parse(URI.escape("#{@host}#{path}"))
      http = @disable_proxy ? Net::HTTP.new(uri.host, uri.port, nil, nil) : Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless @ssl_enabled

      request = build_request(type, uri, options)
      response = http.request(request)
      @logger.debug "  Response: Code=#{response.code}. Headers=#{response.to_hash}\n  Body=#{response.body}"
      response
    rescue OpenSSL::SSL::SSLError => e
      msg = 'SSL verification failed for the request. Please either:'
      msg += "\n  1. Install the necessary certificate(s) into your cert store"
      msg += ". Using cert store: #{ENV['SSL_CERT_FILE']}" if ENV['SSL_CERT_FILE']
      msg += "\n  2. Set the :ssl_enabled option to false for your iLO client (not recommended)"
      @logger.error msg
      raise e
    rescue SocketError => e
      e.message.prepend("Failed to connect to iLO host #{@host}!\n")
      raise e
    end

    # Make a restful GET request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_get(path)
      rest_api(:get, path, {})
    end

    # Make a restful POST request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_post(path, options = {})
      rest_api(:post, path, options)
    end

    # Make a restful PUT request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_put(path, options = {})
      rest_api(:put, path, options)
    end

    # Make a restful PATCH request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_patch(path, options = {})
      rest_api(:patch, path, options)
    end

    # Make a restful DELETE request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_delete(path, options = {})
      rest_api(:delete, path, options)
    end

    RESPONSE_CODE_OK           = 200
    RESPONSE_CODE_CREATED      = 201
    RESPONSE_CODE_ACCEPTED     = 202
    RESPONSE_CODE_NO_CONTENT   = 204
    RESPONSE_CODE_BAD_REQUEST  = 400
    RESPONSE_CODE_UNAUTHORIZED = 401
    RESPONSE_CODE_NOT_FOUND    = 404

    # Handle the response for rest call.
    #   If an asynchronous task was started, this waits for it to complete.
    # @param [HTTPResponse] HTTP response
    # @raise [ILO_SDK::BadRequest] if the request failed with a 400 status
    # @raise [ILO_SDK::Unauthorized] if the request failed with a 401 status
    # @raise [ILO_SDK::NotFound] if the request failed with a 404 status
    # @raise [ILO_SDK::RequestError] if the request failed with any other status
    # @return [Hash] The parsed JSON body
    def response_handler(response)
      case response.code.to_i
      when RESPONSE_CODE_OK # Synchronous read/query
        begin
          return JSON.parse(response.body)
        rescue JSON::ParserError => e
          @logger.warn "Failed to parse JSON response. #{e}"
          return response.body
        end
      when RESPONSE_CODE_CREATED # Synchronous add
        return JSON.parse(response.body)
      when RESPONSE_CODE_ACCEPTED # Asynchronous add, update or delete
        return JSON.parse(response.body) # TODO: Remove when tested
        # TODO: Make this actually wait for the task
        # @logger.debug "Waiting for task: #{response.header['location']}"
        # task = wait_for(response.header['location'])
        # return true unless task['associatedResource'] && task['associatedResource']['resourceUri']
        # resource_data = rest_get(task['associatedResource']['resourceUri'])
        # return JSON.parse(resource_data.body)
      when RESPONSE_CODE_NO_CONTENT # Synchronous delete
        return {}
      when RESPONSE_CODE_BAD_REQUEST
        raise BadRequest, "400 BAD REQUEST #{response.body}"
      when RESPONSE_CODE_UNAUTHORIZED
        raise Unauthorized, "401 UNAUTHORIZED #{response.body}"
      when RESPONSE_CODE_NOT_FOUND
        raise NotFound, "404 NOT FOUND #{response.body}"
      else
        raise RequestError, "#{response.code} #{response.body}"
      end
    end


    private

    # @param type [Symbol] The type of request object to build (get, post, put, patch, or delete)
    # @param uri [URI] URI object
    # @param options [Hash] Options for building the request. All options except "body" are set as headers.
    # @raise [ILO_SDK::InvalidRequest] if the request type is not recognized
    def build_request(type, uri, options)
      case type.downcase
      when 'get', :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when 'post', :post
        request = Net::HTTP::Post.new(uri.request_uri)
      when 'put', :put
        request = Net::HTTP::Put.new(uri.request_uri)
      when 'patch', :patch
        request = Net::HTTP::Patch.new(uri.request_uri)
      when 'delete', :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        raise InvalidRequest, "Invalid rest call: #{type}"
      end
      options['Content-Type'] ||= 'application/json'
      options.delete('Content-Type') if [:none, 'none', nil].include?(options['Content-Type'])
      auth = true
      if [:none, 'none'].include?(options['auth'])
        options.delete('auth')
        auth = false
      end
      options.each do |key, val|
        if key.to_s.downcase == 'body'
          request.body = val.to_json rescue val
        else
          request[key] = val
        end
      end

      filtered_options = options.to_s
      filtered_options.gsub!(@password, 'filtered') if @password
      @logger.debug "  Options: #{filtered_options}"

      request.basic_auth(@user, @password) if auth
      request
    end
  end
end
