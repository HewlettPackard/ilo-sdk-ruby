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
  # Contains helper methods for Firmware Update actions
  module FirmwareUpdateHelper
    # Get the Firmware Version
    # @raise [RuntimeError] if the request failed
    # @return [String] fw_version
    def get_fw_version
      response = rest_get('/redfish/v1/Systems/1/FirmWareInventory/')
      response_handler(response)['Current']['SystemBMC'][0]['VersionString']
    end

    # Set the Firmware Upgrade
    # @param [String, Symbol] uri
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_fw_upgrade(uri, tpm_override_flag = true)
      new_action = { 'Action' => 'InstallFromURI', 'FirmwareURI' => uri, 'TPMOverrideFlag' => tpm_override_flag }
      response = rest_post('/redfish/v1/Managers/1/UpdateService/', body: new_action)
      response_handler(response)
      true
    end
  end
end
