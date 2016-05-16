require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  #describe '#get_asset_tag' do
  #  it 'makes a GET rest call' do
  #    fake_response = FakeResponse.new('AssetTag' => 'HP001')
  #    expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
  #    state = @client.get_asset_tag
  #    expect(state).to eq('HP001')
  #  end
  #end

  #describe '#set_asset_tag' do
  #  it 'makes a PATCH rest call' do
  #    options = { 'AssetTag' => 'HP002' }
  #    expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: options).and_return(FakeResponse.new)
  #    ret_val = @client.set_asset_tag('HP002')
  #    expect(ret_val).to eq(true)
  #  end
  #end

  describe '#get_power_metrics' do
    it 'makes a GET rest call' do
      body = {
        'links' => {
          'Member' => [
            {
              'href' => '/redfish/v1/Chassis/1/'
            }
          ]
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Chassis/').and_return(fake_response)
      body = {
        'links' => {
          'PowerMetrics' => {
            'href' => '/redfish/v1/Chassis/PowerMetrics/'
          }
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Chassis/1/').and_return(fake_response)
      body = {
        'PowerSupplies' => [
          {
            'LineInputVoltage' => '',
            'LineInputVoltageType' => '',
            'PowerCapacityWatts' => '',
            'PowerSupplyType' => '',
            'Status' => {
              'Health' => '',
              'State' => ''
            }
          }
        ],
        'PowerCapacityWatts' => '',
        'PowerConsumedWatts' => ''
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Chassis/PowerMetrics/').and_return(fake_response)
      power_metrics = @client.get_power_metrics
      expect(power_metrics).to eq(
        {
          @client.host => {
            'PowerCapacityWatts' => '',
            'PowerConsumedWatts' => '',
            'PowerSupplies' => [
              {
                'LineInputVoltage' => '',
                'LineInputVoltageType' => '',
                'PowerCapacityWatts' => '',
                'PowerSupplyType' => '',
                'Health' => '',
                'State' => ''
              }
            ]
          }
        }
      )
    end
  end

  describe '#get_thermal_metrics' do
    it 'makes a GET rest call' do
      body = {
        'links' => {
          'Member' => [
            {
              'href' => '/redfish/v1/Chassis/1/'
            }
          ]
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Chassis/').and_return(fake_response)
      body = {
        'links' => {
          'ThermalMetrics' => {
            'href' => '/redfish/v1/Chassis/ThermalMetrics/'
          }
        }
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Chassis/1/').and_return(fake_response)
      body = {
        'Temperatures' => [
          {
            'PhysicalContext' => '',
            'Name' => '',
            'ReadingCelsius' => '',
            'LowerThresholdCritical' => '',
            'Status' => {
              'Health' => '',
              'State' => ''
            }
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/Chassis/ThermalMetrics/').and_return(fake_response)
      thermal_metrics = @client.get_thermal_metrics
      expect(thermal_metrics).to eq(
        {
          @client.host => [
            {
              'PhysicalContext' => '',
              'Name' => '',
              'CurrentReading' => '',
              'CriticalThreshold' => '',
              'Health' => '',
              'State' => ''
            }
          ]
        }
      )
    end
  end
end
