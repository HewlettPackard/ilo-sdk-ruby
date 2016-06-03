# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

module ILO_SDK
  # Contains helper methods for Power actions
  module PowerHelper
    # Get the Power State
    # @raise [RuntimeError] if the request failed
    # @return [String] power_state
    def get_power_state
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['PowerState']
    end

    # Set the Power State
    # @param [String, Symbol] state
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_power_state(state)
      new_action = { 'Action' => 'Reset', 'ResetType' => state }
      response = rest_post('/redfish/v1/Systems/1/', body: new_action)
      response_handler(response)
      true
    end

    # Reset the iLO
    # @raise [RuntimeError] if the request failed
    # @return true
    def reset_ilo
      new_action = { 'Action' => 'Reset' }
      response = rest_post('/redfish/v1/Managers/1/', body: new_action)
      response_handler(response)
      true
    end
  end
end
