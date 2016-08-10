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

module ILO_SDK
  # Contains helper methods for Bios actions
  module BiosHelper
    # Get the BIOS settings
    # @param [Array] setting_names
    # @raise [RuntimeError] if the request failed
    # @return [Hash] bios_settings
    def get_bios_settings(setting_names = nil)
      response = rest_get('/redfish/v1/Systems/1/bios/Settings/')
      bios = response_handler(response)
      return bios unless setting_names
      bios.select { |key, _value| setting_names.include?(key) }
    end

    # Set the BIOS settings
    # @param [Hash] bios
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_bios_settings(bios)
      response = rest_patch('/redfish/v1/Systems/1/bios/Settings/', body: bios)
      response_handler(response)
      true
    end

    # Revert the BIOS
    # @raise [RuntimeError] if the request failed
    # @return true
    def revert_bios
      new_action = { 'BaseConfig' => 'default' }
      response = rest_patch('/redfish/v1/Systems/1/bios/Settings/', body: new_action)
      response_handler(response)
      true
    end
  end
end
