require 'logger'
require_relative 'rest'
# Load all helpers:
Dir[File.join(File.dirname(__FILE__), '/helpers/*.rb')].each { |file| require file }

module ILO_SDK
  # The client defines the connection to the iLO and handles communication with it
  class Client
    attr_accessor :host, :user, :password, :ssl_enabled, :logger, :log_level

    # Create a client object
    # @param [Hash] options the options to configure the client
    # @option options [String] :host URL, hostname, or IP address of the iLO
    # @option options [String] :user ('Administrator') Username to use for authentication with the iLO
    # @option options [String] :password Password to use for authentication with the iLO
    # @option options [Logger] :logger (Logger.new(STDOUT)) Logger object to use.
    #   Must implement debug(String), info(String), warn(String), error(String), & level=
    # @option options [Symbol] :log_level (:info) Log level. Logger must define a constant with this name. ie Logger::INFO
    # @option options [Boolean] :ssl_enabled (true) Use ssl for requests?
    def initialize(options = {})
      options = Hash[options.map { |k, v| [k.to_sym, v] }] # Convert string hash keys to symbols
      @logger = options[:logger] || Logger.new(STDOUT)
      [:debug, :info, :warn, :error, :level=].each { |m| raise "Logger must respond to #{m} method " unless @logger.respond_to?(m) }
      @log_level = options[:log_level] || :info
      @logger.level = @logger.class.const_get(@log_level.upcase) rescue @log_level
      @host = options[:host]
      raise 'Must set the host option' unless @host
      @host = 'https://' + @host unless @host.start_with?('http://', 'https://')
      @ssl_enabled = options[:ssl_enabled].nil? ? true : options[:ssl_enabled]
      raise 'ssl_enabled option must be either true or false' unless [true, false].include?(@ssl_enabled)
      @logger.warn 'User option not set. Using default (Administrator)' unless options[:user]
      @user = options[:user] || 'Administrator'
      @password = options[:password]
      raise 'Must set the password option' unless @password
    end

    include Rest

    # Include helper modules:
    include Manager_Network_Protocol_Helper
    include Date_Time_Helper
    include Computer_Details_Helper
    include SNMP_Service_Helper
    include Power_Helper
    include Account_Service_Helper
    include Log_Entry_Helper
    include Secure_Boot_Helper
    include Bios_Helper
    include Boot_Settings_Helper
    include Firmware_Update_Helper
    include Virtual_Media_Helper
    include Computer_System_Helper
    include Chassis_Helper
    include Service_Root_Helper
  end
end
