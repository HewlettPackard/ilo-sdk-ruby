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

module ILO_SDK
  # Contains helper methods for Computer System actions
  module ComputerSystemHelper
    # Get the computer system settings
    # @param system_id [Integer, String] ID of the system
    # @raise [RuntimeError] if the request failed
    # @return [Hash] Computer system settings
    def get_system_settings(system_id = 1)
      response_handler(rest_get("/redfish/v1/Systems/#{system_id}/"))
    end

    # Set computer system settings
    # @param options [Hash] Hash of options to set
    # @param system_id [Integer, String] ID of the system
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_system_settings(options, system_id = 1)
      response_handler(rest_patch("/redfish/v1/Systems/#{system_id}/", body: options))
      true
    end

    # Get the Asset Tag
    # @deprecated Use {#get_system_settings} instead
    # @raise [RuntimeError] if the request failed
    # @return [String] asset_tag
    def get_asset_tag
      @logger.warn '[Deprecated] `get_asset_tag` is deprecated. Please use `get_system_settings[\'AssetTag\']` instead.'
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['AssetTag']
    end

    # Set the Asset Tag
    # @deprecated Use {#set_system_settings} instead
    # @param asset_tag [String, Symbol]
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_asset_tag(asset_tag)
      @logger.warn '[Deprecated] `set_asset_tag` is deprecated. Please use `set_system_settings(AssetTag: <tag>)` instead.'
      new_action = { 'AssetTag' => asset_tag }
      response = rest_patch('/redfish/v1/Systems/1/', body: new_action)
      response_handler(response)
      true
    end

    # Get the UID indicator LED state
    # @deprecated Use {#get_system_settings} instead
    # @raise [RuntimeError] if the request failed
    # @return [String] indicator_led
    def get_indicator_led
      @logger.warn '[Deprecated] `get_indicator_led` is deprecated. Please use `get_system_settings[\'IndicatorLED\']` instead.'
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['IndicatorLED']
    end

    # Set the UID indicator LED
    # @deprecated Use {#set_system_settings} instead
    # @param state [String, Symbol]
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_indicator_led(state)
      @logger.warn '[Deprecated] `set_indicator_led` is deprecated. Please use `set_system_settings(IndicatorLED: <state>)` instead.'
      new_action = { 'IndicatorLED' => state }
      response = rest_patch('/redfish/v1/Systems/1/', body: new_action)
      response_handler(response)
      true
    end
  end
end
