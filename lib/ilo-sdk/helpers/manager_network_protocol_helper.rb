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
  # Contains helper methods for Manager Network Protocol actions
  module ManagerNetworkProtocolHelper
    # Get the Session Timeout Minutes
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] timeout
    def get_timeout
      response = rest_get('/redfish/v1/Managers/1/NetworkService/')
      response_handler(response)['SessionTimeoutMinutes']
    end

    # Set the Session Timeout Minutes
    # @param [Fixnum] timeout
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_timeout(timeout)
      new_action = { 'SessionTimeoutMinutes' => timeout }
      response = rest_patch('/redfish/v1/Managers/1/NetworkService/', body: new_action)
      response_handler(response)
      true
    end
  end
end
