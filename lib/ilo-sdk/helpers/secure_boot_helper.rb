module ILO_SDK
  # Contains helper methods for Secure Boot actions
  module Secure_Boot_Helper
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
