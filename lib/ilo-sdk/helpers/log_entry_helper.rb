# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

module ILO_SDK
  # Contains helper methods for Log Entry actions
  module LogEntryHelper
    # Clear the specified logs
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return true
    def clear_logs(log_type)
      new_action = { 'Action' => 'ClearLog' }
      response = rest_post("/redfish/v1/Managers/1/LogServices/#{log_type}/", body: new_action)
      response_handler(response)
      true
    end

    # Check to see if the specified logs are empty
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return [TrueClass, FalseClass] logs_empty
    def logs_empty?(log_type)
      response = rest_get("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/")
      response_handler(response)['Items'].empty?
    end

    # Get the specified logs
    # @param [String, Symbol] severity_level
    # @param [String, Symbol] duration
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return logs
    def get_logs(severity_level, duration, log_type)
      response = rest_get("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/")
      entries = response_handler(response)['Items']
      logs = []
      entries.each do |e|
        if severity_level.nil?
          logs.push("#{e['Severity']} | #{e['Message']} | #{e['Created']}") if Time.parse(e['Created']) > (Time.now.utc - (duration * 3600))
        elsif e['Severity'] == severity_level && Time.parse(e['Created']) > (Time.now.utc - (duration * 3600))
          logs.push("#{e['Severity']} | #{e['Message']} | #{e['Created']}")
        end
      end
      logs
    end
  end
end
