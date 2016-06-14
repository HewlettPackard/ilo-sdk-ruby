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
  # Contains helper methods for SNMP Service actions
  module SNMPServiceHelper
    # Get the SNMP Mode
    # @raise [RuntimeError] if the request failed
    # @return [String] snmp_mode
    def get_snmp_mode
      response = rest_get('/redfish/v1/Managers/1/SnmpService/')
      response_handler(response)['Mode']
    end

    # Get the SNMP Alerts Enabled value
    # @raise [RuntimeError] if the request failed
    # @return [String] snmp_alerts_enabled
    def get_snmp_alerts_enabled
      response = rest_get('/redfish/v1/Managers/1/SnmpService/')
      response_handler(response)['AlertsEnabled']
    end

    # Set the SNMP Mode and Alerts Enabled value
    # @param [String, Symbol] snmp_mode
    # @param [Boolean] snmp_alerts
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_snmp(snmp_mode, snmp_alerts)
      new_action = { 'Mode' => snmp_mode, 'AlertsEnabled' => snmp_alerts }
      response = rest_patch('/redfish/v1/Managers/1/SnmpService/', body: new_action)
      response_handler(response)
      true
    end
  end
end
