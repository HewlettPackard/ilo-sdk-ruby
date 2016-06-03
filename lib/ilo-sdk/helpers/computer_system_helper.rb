# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

module ILO_SDK
  # Contains helper methods for Computer System actions
  module ComputerSystemHelper
    # Get the Asset Tag
    # @raise [RuntimeError] if the request failed
    # @return [String] asset_tag
    def get_asset_tag
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['AssetTag']
    end

    # Set the Asset Tag
    # @param [String, Symbol] asset_tag
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_asset_tag(asset_tag)
      new_action = { 'AssetTag' => asset_tag }
      response = rest_patch('/redfish/v1/Systems/1/', body: new_action)
      response_handler(response)
      true
    end

    # Get the UID indicator LED state
    # @raise [RuntimeError] if the request failed
    # @return [String] indicator_led
    def get_indicator_led
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['IndicatorLED']
    end

    # Set the UID indicator LED
    # @param [String, Symbol] state
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_indicator_led(state)
      new_action = { 'IndicatorLED' => state }
      response = rest_patch('/redfish/v1/Systems/1/', body: new_action)
      response_handler(response)
      true
    end
  end
end
