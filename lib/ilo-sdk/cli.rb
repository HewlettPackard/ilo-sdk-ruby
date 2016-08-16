# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'thor'
require 'json'
require 'yaml'

module ILO_SDK
  # cli for ilo-sdk
  class Cli < Thor
    # Runner class to enable testing
    class Runner
      def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
        @argv = argv
        @stdin = stdin
        @stdout = stdout
        @stderr = stderr
        @kernel = kernel
      end

      def execute!
        exit_code = begin
          $stderr = @stderr
          $stdin  = @stdin
          $stdout = @stdout

          ILO_SDK::Cli.start(@argv)
          0
        rescue StandardError => e
          b = e.backtrace
          @stderr.puts("#{b.shift}: #{e.message} (#{e.class})")
          @stderr.puts(b.map { |s| "\tfrom #{s}" }.join("\n"))
          1
        rescue SystemExit => e
          e.status
        end

        # Proxy our exit code back to the injected kernel.
        @kernel.exit(exit_code)
      end
    end

    class_option :ssl_verify,
      type: :boolean,
      desc: 'Enable/Disable SSL verification for requests. Can also use ENV[\'ILO_SSL_ENABLED\']',
      default: nil

    class_option :host,
      desc: 'Hostname or URL of iLO. Can also use ENV[\'ILO_HOST\']'

    class_option :user,
      desc: 'Username. Can also use ENV[\'ILO_USER\']',
      aliases: '-u'

    class_option :log_level,
      desc: 'Log level to use',
      aliases: '-l',
      enum: %w(debug info warn error),
      default: 'warn'

    map ['-v', '--version'] => :version


    method_option :format,
      desc: 'Output format',
      aliases: '-f',
      enum: %w(json yaml human),
      default: 'human'
    desc 'env', 'Show environment variables for ilo-sdk for Ruby'
    def env
      data = {}
      ILO_SDK::ENV_VARS.each { |k| data[k] = ENV[k] }
      if @options['format'] == 'human'
        data.each do |key, value|
          value = "'#{value}'" if value && ! %w(true false).include?(value)
          printf "%-#{data.keys.max_by(&:length).length}s = %s\n", key, value || 'nil'
        end
      else
        output(parse_hash(data, true))
      end
    end

    desc 'console', 'Open a Ruby console with a connection to iLO'
    def console
      client_setup({}, true, true)
      puts "Connected to #{@client.host}"
      puts "HINT: The @client object is available to you\n\n"
    rescue
      puts "WARNING: Couldn't connect to #{@options['host'] || ENV['ILO_HOST'] || 'nil (host not set)'}\n\n"
    ensure
      require 'pry'
      Pry.config.prompt = proc { '> ' }
      Pry.plugins['stack_explorer'] && Pry.plugins['stack_explorer'].disable!
      Pry.plugins['byebug'] && Pry.plugins['byebug'].disable!
      Pry.start(ILO_SDK::Console.new(@client))
    end

    desc 'version', 'Print gem and iLO API versions'
    def version
      puts "Gem Version: #{ILO_SDK::VERSION}"
      client_setup({ 'log_level' => :error }, true)
      ver = @client.response_handler(@client.rest_get('/redfish/v1/'))['RedfishVersion']
      puts "iLO Redfish API version: #{ver}"
    rescue StandardError, SystemExit
      puts 'iLO API version unknown'
    end

    desc 'login', 'Attempt loading an authenticated API endpoint'
    def login
      client_setup
      @client.response_handler(@client.rest_get('/redfish/v1/Sessions/'))
      puts 'Login Successful!'
    end

    private

    def fail_nice(msg = nil)
      puts "ERROR: #{msg}" if msg
      exit 1
    end

    def client_setup(client_params = {}, quiet = false, throw_errors = false)
      client_params['ssl_enabled'] = true if @options['ssl_verify'] == true
      client_params['ssl_enabled'] = false if @options['ssl_verify'] == false
      client_params['host'] ||= @options['host'] if @options['host']
      client_params['user'] ||= @options['user'] if @options['user']
      client_params['log_level'] ||= @options['log_level'].to_sym if @options['log_level']
      @client = ILO_SDK::Client.new(client_params)
    rescue StandardError => e
      raise e if throw_errors
      fail_nice if quiet
      fail_nice "Failed to login to iLO at '#{client_params['host'] || ENV['ILO_HOST']}'. Message: #{e}"
    end

    # Parse options hash from input. Handles chaining and keywords such as true/false & nil
    # Returns new hash with proper nesting and formatting
    def parse_hash(hash, convert_types = false)
      new_hash = {}
      hash.each do |k, v|
        if convert_types
          v = v.to_i if v && v.match(/^\d+$/)
          v = true if v == 'true'
          v = false if v == 'false'
          v = nil if v == 'nil'
        end
        if k =~ /\./
          sub_hash = new_hash
          split = k.split('.')
          split.each do |sub_key|
            if sub_key == split.last
              sub_hash[sub_key] = v
            else
              sub_hash[sub_key] ||= {}
              sub_hash = sub_hash[sub_key]
            end
          end
          new_hash[split.first] ||= {}
        else
          new_hash[k] = v
        end
      end
      new_hash
    end

    # Print output in a given format.
    def output(data = {}, indent = 0)
      case @options['format']
      when 'json'
        puts JSON.pretty_generate(data)
      when 'yaml'
        puts data.to_yaml
      else
        # rubocop:disable Metrics/BlockNesting
        if data.class == Hash
          data.each do |k, v|
            if v.class == Hash || v.class == Array
              puts "#{' ' * indent}#{k.nil? ? 'nil' : k}:"
              output(v, indent + 2)
            else
              puts "#{' ' * indent}#{k.nil? ? 'nil' : k}: #{v.nil? ? 'nil' : v}"
            end
          end
        elsif data.class == Array
          data.each do |d|
            if d.class == Hash || d.class == Array
              output(d, indent + 2)
            else
              puts "#{' ' * indent}#{d.nil? ? 'nil' : d}"
            end
          end
          puts "\nTotal: #{data.size}" if indent < 1
        else
          puts "#{' ' * indent}#{data.nil? ? 'nil' : data}"
        end
        # rubocop:enable Metrics/BlockNesting
      end
    end
  end

  # Console class
  class Console
    def initialize(client)
      @client = client
    end
  end
end
