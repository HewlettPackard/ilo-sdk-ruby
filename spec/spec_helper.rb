require 'pry'
require 'simplecov'

client_files = %w(client.rb rest.rb)
helper_path = 'lib/ilo-sdk/helpers'

SimpleCov.start do
  add_filter 'spec/'
  add_group 'Client', client_files
  add_group 'Helpers', helper_path
  minimum_coverage 89 # TODO: bump up as we increase coverage. Goal: 95%
  minimum_coverage_by_file 10 # TODO: bump up as we increase coverage. Goal: 90%
end

require 'ilo-sdk'
require_relative 'shared_context'
require_relative 'support/fake_response'

RSpec.configure do |config|
  config.before(:each) do
    ILO_SDK::ENV_VARS.each { |e| ENV[e] = nil } # Clear environment variables
  end
end
