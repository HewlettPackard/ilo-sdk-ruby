module ILO_SDK
  # Contains helper methods for Firmware Update actions
  module Firmware_Update_Helper
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
