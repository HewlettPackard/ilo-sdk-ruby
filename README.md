# Ruby SDK for HPE iLO
[![Gem Version](https://badge.fury.io/rb/ilo-sdk.svg)](https://badge.fury.io/rb/ilo-sdk)

Software Development Kit for interacting with the Hewlett Packard Enterprise iLO (Integrated Lights-Out) server management technology.

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
client = ILO_SDK::Client.new(
  host: 'https://ilo.example.com',
  user: 'Administrator',              # This is the default
  password: 'secret123',
  ssl_enabled: true,                  # This is the default and strongly encouraged
  logger: Logger.new(STDOUT),         # This is the default
  log_level: :info                   # This is the default
)
```

:lock: Tip: Check the file permissions when storing passwords in clear-text.

#### Environment Variables

You can also set many client options using environment variables. For bash:

```bash
export ILO_HOST='https://oneview.example.com'
export ILO_USER='Administrator'
export ILO_PASSWORD='secret123'
export ILO_SSL_ENABLED=false # NOTE: Disabling SSL is strongly discouraged. Please see the CLI section for import instructions.
```

:lock: Tip: Be sure nobody can access to your environment variables

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
# Get BIOS base configuration:
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

# Get the URL boot file:
url_boot_file = client.get_url_boot_file

# Set the URL boot file:
client.set_url_boot_file('http://www.urlbootfile.iso')

# Get BIOS service settings:
bios_service_settings = client.get_bios_service

# Set BIOS service settings:
service_name = 'my_name'
service_email = 'my_name@hpe.com'
client.set_bios_service(service_name, service_email)
```

#### Boot Settings
```ruby
# Get boot order base configuration:
baseconfig = client.get_boot_baseconfig

# Revert the boot:
client.revert_boot

# Get boot order:
boot_order = client.get_boot_order

# Set boot order:
client.set_boot_order([
    "Generic.USB.1.1",
    "NIC.LOM.1.1.IPv4",
    "NIC.LOM.1.1.IPv6",
    "NIC.Slot.1.1.IPv6",
    "HD.Emb.5.2",
    "HD.Emb.5.1",
    "NIC.Slot.1.1.IPv4"
])

# Get temporary boot order:
temporary_boot_order = client.get_temporary_boot_order

# Set temporary boot order:
boot_source_override_target = 'CD'
client.set_temporary_boot_order(boot_source_override_target)
```

#### Chassis
```ruby
# Get power metrics information:
power_metrics = client.get_power_metrics

# Get thermal metrics information:
thermal_metrics = client.get_thermal_metrics
```

#### Computer Details
```ruby
# Get computer details (including general, network, and array controller details):
computer_details = client.get_computer_details

# Get general computer details:
general_details = client.get_general_computer_details

# Get computer network details:
network_details = client.get_computer_network_details

# Get array controller details:
array_controller_details = client.get_array_controller_details
```

#### Computer System
```ruby
# Get the computer system asset tag:
asset_tag = client.get_asset_tag

# Set the computer system asset tag:
client.set_asset_tag('HP001')

# Get the indicator led state:
indicator_led = client.get_indicator_led

# Set the indicator led state:
client.set_indicator_led('Lit')
```

#### Date Time
```ruby
# Get the time zone:
time_zone = client.get_time_zone

# Set the time zone:
client.set_time_zone('Africa/Abidjan')

# Get whether or not NTP servers are in use (true or false):
ntp_server_use = client.get_ntp

# Set whether or not to use NTP servers:
client.set_ntp(true)

# Get a list of NTP servers:
ntp_servers = client.get_ntp_servers

# Set the NTP servers:
ntp_servers = ['10.1.1.1', '10.1.1.2']
client.set_ntp_server(ntp_servers)
```

#### Firmware
```ruby
# Get the firmware version:
fw_version = client.get_fw_version

# Set the firmware URI for a firmware upgrade:
client.set_fw_upgrade('www.firmwareupgrade.com')
```

#### HTTPS Certificate
```ruby
# Get the current SSL Certificate and check to see if expires within 24 hours
expiration = client.get_certificate.not_after.to_datetime
tomorrow = DateTime.now + 1

if expiration < tomorrow
  # Generate a Certificate Signing Request:
  # Params: country_code, state, city, organization, organizational_unit, common_name
  client.generate_csr('US', 'Texas', 'Houston', 'myCompany', 'myUnit', 'example.com')

  # Wait for the CSR to be generated (will take about 10 minutes):
  csr = nil
  while(csr.nil?) do
    sleep(60) # 60 seconds
    csr = client.get_csr
  end

  # Here you'll need to have a step that submits the csr to a certificate authority
  # (or self-signs it) and gets back the signed certificate. It will look something like:
  # -----BEGIN CERTIFICATE-----
  # lines_of_secret_text
  # -----END CERTIFICATE-----
  # For this example, we're assuming we've read in the content of the certificate to the
  # "cert" variable (as a string).

  client.import_certificate(cert)
end
```

#### Log Entry
```ruby
# Clear a specific type of logs:
log_type = 'IEL'
client.clear_logs(log_type)

# Check to see if a specific type of logs are empty:
empty = client.logs_empty?(log_type)

# Get a specific type of logs based on severity level and duration:
severity_level = 'OK'
duration = 10 # hours
logs = client.get_log(severity_level, duration, log_type)
```

### Manager Account
```ruby
# Get the Account Privileges for a specific user:
username = 'Administrator'
client.get_account_privileges(username)

# Set the Login Privilege to true for a specific user:
client.set_account_privileges(username, LoginPriv: true)

# Set all of the Account Privileges for a specific user:
privileges = {
  'LoginPriv' => true,
  'RemoteConsolePriv' => true,
  'UserConfigPriv' => true,
  'VirtualMediaPriv' => true,
  'VirtualPowerAndResetPriv' => true,
  'iLOConfigPriv' => true
}
client.set_account_privileges(username, privileges)
```

#### Manager Network Protocol
```ruby
# Get the minutes until session timeout:
timeout = client.get_timeout

# Set the minutes until session timeout:
client.set_timeout(60)
```

#### Power
```ruby
# Get the power state of the system:
power_state = client.get_power_state

# Set the power state of the system:
client.set_power_state('On')

# Reset the iLO:
client.reset_ilo
```

#### Secure Boot
```ruby
# Get whether or not UEFI secure boot is enabled:
uefi_secure_boot = client.get_uefi_secure_boot

# Set whether or not UEFI secure boot is enabled:
client.set_uefi_secure_boot(true)
```

#### Service Root
```ruby
# Get the schema information with a given prefix:
schema_prefix = 'Account'
schema = client.get_schema(schema_prefix)

# Get the registry information with a  given prefix:
registry_prefix = 'Base'
registry = client.get_registry(registry_prefix)
```

#### SNMP
```ruby
# Get the SNMP mode:
snmp_mode = client.get_snmp_mode

# Get whether or not SNMP Alerts are enabled:
snmp_alerts_enabled = client.get_snmp_alerts_enabled

# Set the SNMP mode and whether or not SNMP Alerts are enabled:
snmp_mode = 'Agentless'
snmp_alerts_enabled = true
client.set_snmp(snmp_mode, snmp_alerts_enabled)
```

#### Virtual Media
```ruby
# Get the virtual media information:
virtual_media = client.get_virtual_media

# Get whether or not virtual media is inserted for a certain id:
id = 1
virtual_media_inserted = client.virtual_media_inserted?(id)

# Insert virtual media at a certain id:
image = 'http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso'
client.insert_virtual_media(id, image)

# Eject virtual media at a certain id:
client.eject_virtual_media(id)
```

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


## CLI

This gem also comes with a command-line interface to make interracting with the iLO API without needing to create a Ruby program.

Note: In order to use this, you will need to make sure your ruby bin directory is in your path. Run $ gem environment to see where the executable paths are for your Ruby installation.

To get started, run `$ ilo-ruby --help`.

To communicate with an appliance, you will need to set up a few environment variables so it knows how to communicate. Run $ ilo-ruby env to see the available environment variables.

Here are a few examples of how you might want to use the CLI:

##### Start an interactive console session with an iLO connection:

```bash
$ ilo-ruby console
Connected to https://ilo.example.com
HINT: The @client object is available to you
>
```


## License
This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more info.


## Contributing and feature requests
**Contributing:** You know the drill. Fork it, branch it, change it, commit it, and pull-request it.
We are passionate about improving this project, and glad to accept help to make it better. However, keep the following in mind:

 - You must sign a Contributor License Agreement first. Contact one of the authors (from Hewlett Packard Enterprise) for details and the CLA.
 - All pull requests must contain complete test code also. See the testing section below.
 - We reserve the right to reject changes that we feel do not fit the scope of this project, so for feature additions, please open an issue to discuss your ideas before doing the work.

**Feature Requests:** If you have a need that is not met by the current implementation, please let us know (via a new issue).
This feedback is crucial for us to deliver a useful product. Do not assume we have already thought of everything, because we assure you that is not the case.

### Building the Gem
First run `$ bundle` (requires the bundler gem), then...
 - To build only, run `$ rake build`.
 - To build and install the gem, run `$ rake install`.

### Testing
 - RuboCop: `$ rake rubocop`
 - Unit: `$ rake spec`
 - All test: `$ rake test`

Note: run `$ rake -T` to get a list of all the available rake tasks.

## Authors
 - Anirudh Gupta - [@Anirudh-Gupta](https://github.com/Anirudh-Gupta)
 - Bik Bajwa - [@bikbajwa](https://github.com/bikbajwa)
 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
 - Vivek Bhatia - [@vivekbhatia14] (https://github.com/vivekbhatia14)
