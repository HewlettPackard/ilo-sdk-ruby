require_relative './../../spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#userhref' do
    it 'makes a GET rest call' do
      body = {
        'Items' => [
          {
            'UserName' => 'username',
            'links' => {
              'self' => {
                'href' => '/redfish/v1/AccountService/Accounts/1/'
              }
            }
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/AccountService/Accounts/').and_return(fake_response)
      href = @client.userhref('/redfish/v1/AccountService/Accounts/', 'username')
      expect(href).to eq('/redfish/v1/AccountService/Accounts/1/')
    end
  end

  describe '#get_users' do
    it 'makes a GET rest call' do
      body = {
        'Items' => [
          {
            'UserName' => 'username',
            'links' => {
              'self' => {
                'href' => '/redfish/v1/AccountService/Accounts/1/'
              }
            }
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/AccountService/Accounts/').and_return(fake_response)
      users = @client.get_users
      expect(users).to eq(['username'])
    end
  end

  describe '#create_user' do
    it 'makes POST rest call' do
      new_action = {
        'UserName' => 'username',
        'Password' => 'password',
        'Oem' => {
          'Hp' => {
            'LoginName' => 'username'
          }
        }
      }
      expect(@client).to receive(:rest_post).with('/redfish/v1/AccountService/Accounts/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.create_user('username', 'password')
      expect(ret_val).to eq(true)
    end
  end

  describe '#change_password' do
    it 'makes PATCH rest call' do
      new_action = {
        'Password' => 'password'
      }
      expect(@client).to receive(:userhref).with('/redfish/v1/AccountService/Accounts/', 'username').and_return('/redfish/v1/AccountService/Accounts/1/')
      expect(@client).to receive(:rest_patch).with('/redfish/v1/AccountService/Accounts/1/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.change_password('username', 'password')
      expect(ret_val).to eq(true)
    end
  end

  describe '#delete_user' do
    it 'makes DELETE rest call' do
      expect(@client).to receive(:userhref).with('/redfish/v1/AccountService/Accounts/', 'username').and_return('/redfish/v1/AccountService/Accounts/1/')
      expect(@client).to receive(:rest_delete).with('/redfish/v1/AccountService/Accounts/1/').and_return(FakeResponse.new)
      ret_val = @client.delete_user('username')
      expect(ret_val).to eq(true)
    end
  end

  describe '#get_account_privileges' do
    it 'makes a GET rest call' do
      body = {
        'Items' => [
          {
            'Id' => '1',
            'Oem' => {
              'Hp' => {
                'LoginName' => 'test1',
                'Privileges' => {
                  'LoginPriv' => true,
                  'RemoteConsolePriv' => true,
                  'UserConfigPriv' => true,
                  'VirtualMediaPriv' => true,
                  'VirtualPowerAndResetPriv' => true,
                  'iLOConfigPriv' => true
                }
              }
            }
          },
          {
            'Id' => '2',
            'Oem' => {
              'Hp' => {
                'LoginName' => 'test2',
                'Privileges' => {
                  'LoginPriv' => false,
                  'RemoteConsolePriv' => false,
                  'UserConfigPriv' => false,
                  'VirtualMediaPriv' => false,
                  'VirtualPowerAndResetPriv' => false,
                  'iLOConfigPriv' => false
                }
              }
            }
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/AccountService/Accounts/').and_return(fake_response)
      privileges = @client.get_account_privileges('test1')
      expect(privileges).to eq(body['Items'][0]['Oem']['Hp']['Privileges'])
    end
  end

  describe '#set_account_privileges' do
    it 'makes a GET and a PATCH rest call' do
      body = {
        'Items' => [
          {
            'Id' => '1',
            'Oem' => {
              'Hp' => {
                'LoginName' => 'test1',
                'Privileges' => {
                  'LoginPriv' => true,
                  'RemoteConsolePriv' => true,
                  'UserConfigPriv' => true,
                  'VirtualMediaPriv' => true,
                  'VirtualPowerAndResetPriv' => true,
                  'iLOConfigPriv' => true
                }
              }
            }
          },
          {
            'Id' => '2',
            'Oem' => {
              'Hp' => {
                'LoginName' => 'test2',
                'Privileges' => {
                  'LoginPriv' => false,
                  'RemoteConsolePriv' => false,
                  'UserConfigPriv' => false,
                  'VirtualMediaPriv' => false,
                  'VirtualPowerAndResetPriv' => false,
                  'iLOConfigPriv' => false
                }
              }
            }
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/AccountService/Accounts/').and_return(fake_response)
      username = 'test1'
      privileges = {
        'LoginPriv' => false,
        'RemoteConsolePriv' => false,
        'UserConfigPriv' => false,
        'VirtualMediaPriv' => false,
        'VirtualPowerAndResetPriv' => false,
        'iLOConfigPriv' => false
      }
      new_action = {
        'Oem' => {
          'Hp' => {
            'Privileges' => privileges
          }
        }
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/AccountService/Accounts/1/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_account_privileges(username, privileges)
      expect(ret_val).to eq(true)
    end

    it 'makes a GET and a PATCH (only on some attributes) rest call' do
      body = {
        'Items' => [
          {
            'Id' => '1',
            'Oem' => {
              'Hp' => {
                'LoginName' => 'test1',
                'Privileges' => {
                  'LoginPriv' => true,
                  'RemoteConsolePriv' => true,
                  'UserConfigPriv' => true,
                  'VirtualMediaPriv' => true,
                  'VirtualPowerAndResetPriv' => true,
                  'iLOConfigPriv' => true
                }
              }
            }
          },
          {
            'Id' => '2',
            'Oem' => {
              'Hp' => {
                'LoginName' => 'test2',
                'Privileges' => {
                  'LoginPriv' => false,
                  'RemoteConsolePriv' => false,
                  'UserConfigPriv' => false,
                  'VirtualMediaPriv' => false,
                  'VirtualPowerAndResetPriv' => false,
                  'iLOConfigPriv' => false
                }
              }
            }
          }
        ]
      }
      fake_response = FakeResponse.new(body)
      expect(@client).to receive(:rest_get).with('/redfish/v1/AccountService/Accounts/').and_return(fake_response)
      username = 'test1'
      privileges = {
        'LoginPriv' => false,
        'RemoteConsolePriv' => false,
        'UserConfigPriv' => false
      }
      new_action = {
        'Oem' => {
          'Hp' => {
            'Privileges' => privileges
          }
        }
      }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/AccountService/Accounts/1/', body: new_action).and_return(FakeResponse.new)
      ret_val = @client.set_account_privileges(username, privileges)
      expect(ret_val).to eq(true)
    end
  end
end
