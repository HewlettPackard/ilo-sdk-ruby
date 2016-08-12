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

require 'logger'
require_relative 'rest'
# Load all helpers:
Dir[File.join(File.dirname(__FILE__), '/helpers/*.rb')].each { |file| require file }

module ILO_SDK
  # The client defines the connection to the iLO and handles communication with it
  class Client
    attr_accessor :host, :user, :password, :ssl_enabled, :disable_proxy, :logger, :log_level

    # Create a client object
    # @param [Hash] options the options to configure the client
    # @option options [String] :host (ENV['ILO_HOST']) URL, hostname, or IP address of the iLO
    # @option options [String] :user ('Administrator') Username to use for authentication with the iLO
    # @option options [String] :password Password to use for authentication with the iLO
    # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests?
    # @option options [Boolean] :disable_proxy (false) Disable usage of a proxy for requests?
    def initialize(options = {})
      options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
      @logger = options[:logger] || Logger.new(STDOUT)
      [:debug, :info, :warn, :error, :level=].each { |m| raise "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
      @log_level = options[:log_level] || :info
      @logger.level = @logger.class.const_get(@log_level.upcase) rescue @log_level
      @host = options[:host] || ENV['ILO_HOST']
      raise InvalidClient, 'Must set the host option' unless @host
      @host = 'https://' + @host unless @host.start_with?('http://', 'https://')
      @ssl_enabled = true # Default
      if ENV.key?('ILO_SSL_ENABLED')
        @ssl_enabled = case ENV['ILO_SSL_ENABLED']
                       when 'true', '1' then true
                       when 'false', '0' then false
                       else ENV['ILO_SSL_ENABLED']
                       end
      end
      @ssl_enabled = options[:ssl_enabled] unless options[:ssl_enabled].nil?
      unless [true, false].include?(@ssl_enabled)
        raise InvalidClient, "ssl_enabled option must be true or false. Got '#{@ssl_enabled}'"
      end
      unless @ssl_enabled
        @logger.warn "SSL is disabled for all requests to #{@host}! We recommend you import the necessary certificates instead. of disabling SSL"
      end
      @disable_proxy = options[:disable_proxy]
      raise InvalidClient, 'disable_proxy option must be true, false, or nil' unless [true, false, nil].include?(@disable_proxy)
      @logger.warn 'User option not set. Using default (Administrator)' unless options[:user] || ENV['ILO_USER']
      @user = options[:user] || ENV['ILO_USER'] || 'Administrator'
      @password = options[:password] || ENV['ILO_PASSWORD']
      raise InvalidClient, 'Must set the password option' unless @password
    end

    include Rest

    # Include helper modules:
    include ManagerNetworkProtocolHelper
    include DateTimeHelper
    include ComputerDetailsHelper
    include SNMPServiceHelper
    include PowerHelper
    include AccountServiceHelper
    include LogEntryHelper
    include ManagerAccountHelper
    include SecureBootHelper
    include BiosHelper
    include BootSettingsHelper
    include FirmwareUpdateHelper
    include VirtualMediaHelper
    include ComputerSystemHelper
    include ChassisHelper
    include ServiceRootHelper
    include HttpsCertHelper
  end
end
