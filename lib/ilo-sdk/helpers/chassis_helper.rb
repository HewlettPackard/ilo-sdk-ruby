# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

module ILO_SDK
  # Contains helper methods for Chassis actions
  module ChassisHelper
    # Get the power metrics
    # @raise [RuntimeError] if the request failed
    # @return [Hash] power_metrics
    def get_power_metrics
      chassis = rest_get('/redfish/v1/Chassis/')
      chassis_uri = response_handler(chassis)['links']['Member'][0]['href']
      power_metrics_uri = response_handler(rest_get(chassis_uri))['links']['PowerMetrics']['href']
      response = rest_get(power_metrics_uri)
      metrics = response_handler(response)
      power_supplies = []
      metrics['PowerSupplies'].each do |ps|
        power_supply = {
          'LineInputVoltage' => ps['LineInputVoltage'],
          'LineInputVoltageType' => ps['LineInputVoltageType'],
          'PowerCapacityWatts' => ps['PowerCapacityWatts'],
          'PowerSupplyType' => ps['PowerSupplyType'],
          'Health' => ps['Status']['Health'],
          'State' => ps['Status']['State']
        }
        power_supplies.push(power_supply)
      end
      {
        @host => {
          'PowerCapacityWatts' => metrics['PowerCapacityWatts'],
          'PowerConsumedWatts' => metrics['PowerConsumedWatts'],
          'PowerSupplies' => power_supplies
        }
      }
    end

    # Get the thermal metrics
    # @raise [RuntimeError] if the request failed
    # @return [Hash] thermal_metrics
    def get_thermal_metrics
      chassis = rest_get('/redfish/v1/Chassis/')
      chassis_uri = response_handler(chassis)['links']['Member'][0]['href']
      thermal_metrics_uri = response_handler(rest_get(chassis_uri))['links']['ThermalMetrics']['href']
      response = rest_get(thermal_metrics_uri)
      temperatures = response_handler(response)['Temperatures']
      temp_details = []
      temperatures.each do |temp|
        temp_detail = {
          'PhysicalContext' => temp['PhysicalContext'],
          'Name' => temp['Name'],
          'CurrentReading' => temp['ReadingCelsius'],
          'CriticalThreshold' => temp['LowerThresholdCritical'],
          'Health' => temp['Status']['Health'],
          'State' => temp['Status']['State']
        }
        temp_details.push(temp_detail)
      end
      { @host => temp_details }
    end
  end
end
