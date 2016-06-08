# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

module ILO_SDK
  # Contains helper methods for Secure Boot actions
  module SecureBootHelper
    # Get the UEFI secure boot
    # @raise [RuntimeError] if the request failed
    # @return [TrueClass, FalseClass] uefi_secure_boot
    def get_uefi_secure_boot
      response = rest_get('/redfish/v1/Systems/1/SecureBoot/')
      response_handler(response)['SecureBootEnable']
    end

    # Set the UEFI secure boot true or false
    # @param [Boolean] secure_boot_enable
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_uefi_secure_boot(secure_boot_enable)
      new_action = { 'SecureBootEnable' => secure_boot_enable }
      response = rest_patch('/redfish/v1/Systems/1/SecureBoot/', body: new_action)
      response_handler(response)
      true
    end
  end
end
