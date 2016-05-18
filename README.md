# Ruby SDK for HPE iLO
[![Gem Version](https://badge.fury.io/rb/ilo-sdk.svg)](https://badge.fury.io/rb/ilo-sdk)

TODO: Description

## Installation

- Require the gem in your Gemfile:

  ```ruby
  gem 'ilo-sdk'
  ```

  Then run `$ bundle install`
- Or run the command:

  ```bash
  $ gem install ilo-sdk
  ```


## Client
Everything you do with this API happens through a client object.
Creating the client object is the first step; then you can perform actions on the client.

```ruby
require 'ilo-sdk'
client = OneviewSDK::Client.new(
  host: 'https://ilo.example.com',
  user: 'Administrator',              # This is the default
  password: 'secret123',
  ssl_enabled: true,                  # This is the default and strongly encouraged
  logger: Logger.new(STDOUT),         # This is the default
  log_level: :info,                   # This is the default
)
```

:lock: Tip: Check the file permissions because the password is stored in clear-text.

**Environment Variables**

TODO

### Custom logging
The default logger is a standard logger to STDOUT, but if you want to specify your own, you can.  However, your logger must implement the following methods:

```ruby
debug(String)
info(String)
warn(String)
error(String)
level=(Symbol, etc.) # The parameter here will be the log_level attribute
```


## Actions
Actions are performed on the client, and defined in the [helper modules](lib/ilo-sdk/helpers).

#### Account Service
```ruby
# Get list of users:
users = client.get_users
# Create a user:
client.create_user('user1', 'password123')
# Change a user's password:
client.change_password('user1', 'newpassword123')
# Delete a user:
client.delete_user('user1')
```

#### Bios
```ruby
# Get BIOS Base Configuration:
baseconfig = client.get_bios_baseconfig
# Revert BIOS:
client.revert_bios
# Get UEFI shell startup settings:
uefi_shell_startup = client.get_uefi_shell_startup
# Set UEFI shell startup settings:
uefi_shell_startup_location = 'Auto'
uefi_shell_startup_url = 'http://wwww.uefi.com'
client.uefi_shell_startup('Enabled', uefi_shell_startup_location, uefi_shell_startup_url)
# Get BIOS DHCP settings:
bios_dhcp = client.get_bios_dhcp
# Set BIOS DHCP settings:
ipv4_address = '10.1.1.111'
ipv4_gateway = '10.1.1.0'
ipv4_primary_dns = '10.1.1.1'
ipv4_secondary_dns = '10.1.1.2'
ipv4_subnet_mark = '255.255.255.0'
client.set_bios_dhcp('Disabled', ipv4_address, ipv4_gateway, ipv4_primary_dns, ipv4_secondary_dns, ipv4_subnet_mark)
# Get the URL Boot File:
url_boot_file = client.get_url_boot_file
# Set the URL Boot File:
client.set_url_boot_file('http://www.urlbootfile.iso')
# Get BIOS Service settings:
bios_service_settings = client.get_bios_service
# Set BIOS Service settings:
service_name = 'my_name'
service_email = 'my_name@hpe.com'
client.set_bios_service(service_name, service_email)
# Get Boot Order:
boot_order = client.get_boot_order
# Set Boot Order:
client.set_boot_order([
    "Generic.USB.1.1",
    "NIC.LOM.1.1.IPv4",
    "NIC.LOM.1.1.IPv6",
    "NIC.Slot.1.1.IPv6",
    "HD.Emb.5.2",
    "HD.Emb.5.1",
    "NIC.Slot.1.1.IPv4"
])
# Get Temporary Boot Order:
temporary_boot_order = client.get_temporary_boot_order
# Set Temporary Boot Order:
boot_source_override_target = 'CD'
client.set_temporary_boot_order(boot_source_override_target)
```

#### Chassis
TODO

#### Computer Details
TODO

#### Computer System
TODO

#### Date Time
TODO

#### Firmware
TODO

#### Log Entry
TODO

#### Manager Network Protocol
TODO

#### Power
TODO

#### Secure Boot
TODO

#### Service Root
TODO

#### SNMP
TODO

#### Virtual Media
TODO

## Custom requests
In most cases, interacting with the client object is enough, but sometimes you need to make your own custom requests to the iLO.
This project makes it extremely easy to do with some built-in methods for the client object. Here are some examples:

```ruby
# Get a list of schemas:
response = client.rest_api(:get, '/rest/v1/Schemas')
# or even more simple:
response = client.rest_get('/rest/v1/Schemas')

# Then we can validate the response and convert the response body into a hash...
data = client.response_handler(response)
```

This example is about as basic as it gets, but you can make any type of iLO request.
If a resource does not do what you need, this will allow you to do it.
Please refer to the documentation and [code](lib/ilo-sdk/rest.rb) for complete list of methods and information about how to use them.

## License
This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more info.


## Contributing and feature requests
**Contributing:** You know the drill. Fork it, branch it, change it, commit it, and pull-request it.
We are passionate about improving this project, and glad to accept help to make it better.

NOTE: We reserve the right to reject changes that we feel do not fit the scope of this project, so for feature additions, please open an issue to discuss your ideas before doing the work.

**Feature Requests:** If you have a need that is not met by the current implementation, please let us know (via a new issue).
This feedback is crucial for us to deliver a useful product. Do not assume we have already thought of everything, because we assure you that is not the case.

### Building the Gem
First run `$ bundle` (requires the bundler gem), then...
 - To build only, run `$ rake build`.
 - To build and install the gem, run `$ rake install`.

### Testing
 - RuboCop: `$ rake rubocop`
 - Unit: `$ rake spec`
 - All: Run `$ rake test:all` to run RuboCop, unit, & integration tests.

Note: run `$ rake -T` to get a list of all the available rake tasks.

## Authors
 - Anirudh Gupta
 - Bik Bajwa
 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
 - Vivek Bhatia
