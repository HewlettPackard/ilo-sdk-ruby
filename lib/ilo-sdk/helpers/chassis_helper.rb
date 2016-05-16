module ILO_SDK
  # Contains helper methods for Chassis actions
  module Chassis_Helper
    # Get the vital power metrics
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
