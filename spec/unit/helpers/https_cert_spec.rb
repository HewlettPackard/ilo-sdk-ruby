require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'
  #describe '#get_users' do
  #  it 'makes a GET rest call' do
  #    body = {
  #      'Items' => [
  #        {
  #          'UserName' => 'username',
  #          'links' => {
  #            'self' => {
  #              'href' => '/redfish/v1/AccountService/Accounts/1/'
  #            }
  #          }
  #        }
  #      ]
  #    }
  #    fake_response = FakeResponse.new(body)
  #    expect(@client).to receive(:rest_get).with('/redfish/v1/AccountService/Accounts/').and_return(fake_response)
  #    users = @client.get_users
  #    expect(users).to eq(['username'])
  #  end
  #end

  #describe '#create_user' do
  #  it 'makes POST rest call' do
  #    new_action = {
  #      'UserName' => 'username',
  #      'Password' => 'password',
  #      'Oem' => {
  #        'Hp' => {
  #          'LoginName' => 'username'
  #        }
  #      }
  #    }
  #    expect(@client).to receive(:rest_post).with('/redfish/v1/AccountService/Accounts/', body: new_action).and_return(FakeResponse.new)
  #    ret_val = @client.create_user('username', 'password')
  #    expect(ret_val).to eq(true)
  #  end
  #end
end
