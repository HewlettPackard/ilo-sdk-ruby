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
  # Contains helper methods for EthernetInterface actions
  module EthernetInterfaceHelper
    # Get all the Ethernet Interface settings
    # @param manager_id [Integer, String] ID of the Manager
    # @ethernet_interface [Integer, String] ID of the EthernetInterface
    # @raise [RuntimeError] if the request failed
    # @return [Hash] EthernetInterface settings
    def get_ilo_ethernet_interface(manager_id = 1, ethernet_interface = 1)
      response_handler(rest_get("/rest/v1/Managers/#{manager_id}/EthernetInterfaces/#{ethernet_interface}"))
    end

    # Set EthernetInterface to obtain IPv4 address from DHCP
    # @param manager_id [Integer, String] ID of the Manager
    # @ethernet_interface [Integer, String] ID of the EthernetInterface
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_ilo_dhcp(manager_id = 1, ethernet_interface = 1)
      new_action = { 'Oem' => { 'Hp' => { 'DHCPv4' => { 'Enabled' => true } } } }
      response = rest_patch("/rest/v1/Managers/#{manager_id}/EthernetInterfaces/#{ethernet_interface}", body: new_action)
      response_handler(response)
      true
    end

    # Set EthernetInterface to static IPv4 address
    # @paramm ip [String] IPv4 address
    # @param netmask [String] IPv4 subnet mask
    # @param gateway [String] IPv4 default gateway
    # @param manager_id [Integer, String] ID of the Manager
    # @ethernet_interface [Integer, String] ID of the EthernetInterface
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_ilo_static(ip, netmask, gateway='0.0.0.0', manager_id = 1, ethernet_interface = 1)
      new_action = { 
        'Oem' => { 'Hp' => { 'DHCPv4' => { 'Enabled' => false } } }, 
        'IPv4Addresses' => [
          'Address' => ip, 'SubnetMask' => netmask, 'Gateway' => gateway
        ]
      }
      puts new_action
      response = rest_patch("/rest/v1/Managers/#{manager_id}/EthernetInterfaces/#{ethernet_interface}", body: new_action)
      response_handler(response)
      true
    end
    
    # Set EthernetInterface DNS servers
    # @paramm dns_servers [Array] list of DNS servers
    # @param manager_id [Integer, String] ID of the Manager
    # @ethernet_interface [Integer, String] ID of the EthernetInterface
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_ilo_dns_servers(dns_servers, manager_id = 1, ethernet_interface = 1)
      new_action = {
        'Oem' => { 
          'Hp' => { 
            'DHCPv4' => { 'UseDNSServers' => false },
            'IPv4' => { 'DNSServers' => dns_servers }
          }
        }
      }
      response = rest_patch("/rest/v1/Managers/#{manager_id}/EthernetInterfaces/#{ethernet_interface}", body: new_action)
      response_handler(response)
      true
    end
  end
end
