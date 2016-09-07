# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'time'

module ILO_SDK
  # Contains helper methods for Log Entry actions
  module LogEntryHelper
    # Get the URI for the specified log type
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if type is invalid
    # @return [String] URI of log service
    def uri_for_log_type(log_type, id = 1)
      resource = case log_type.to_s.upcase
                 when 'IEL' then 'Managers'
                 when 'IML' then 'Systems'
                 else raise "Invalid log_type '#{log_type}'. Valid options are IEL and IML"
                 end
      "/redfish/v1/#{resource}/#{id}/LogServices/#{log_type.upcase}/"
    end

    # Clear the specified logs
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return true
    def clear_logs(log_type)
      new_action = { 'Action' => 'ClearLog' }
      response = rest_post(uri_for_log_type(log_type), body: new_action)
      response_handler(response)
      true
    end

    # Check to see if the specified logs are empty
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return [TrueClass, FalseClass] logs_empty
    def logs_empty?(log_type)
      response = rest_get("#{uri_for_log_type(log_type)}Entries/")
      response_handler(response)['Items'].empty?
    end

    # Get the specified logs
    # @param [String, Symbol, NilClass] severity_level Set to nil to get all logs
    # @param [String, Symbol] duration Up to this many hours ago
    # @param [String, Symbol] log_type IEL or IML
    # @raise [RuntimeError] if the request failed
    # @return [Array] log entries
    def get_logs(severity_level, duration, log_type)
      response = rest_get("#{uri_for_log_type(log_type)}Entries/")
      entries = response_handler(response)['Items']
      start_time = Time.now.utc - (duration * 3600)
      if severity_level.nil?
        entries.select { |e| Time.parse(e['Created']) > start_time }
      else
        entries.select { |e| severity_level.to_s.casecmp(e['Severity']) == 0 && Time.parse(e['Created']) > start_time }
      end
    end
  end
end
