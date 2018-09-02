# macfirewall

Manage macOS Application Firewall configuration via Puppet

### Module description
The module uses, 'socketfilterfw' to manage firewall.

### Supported Puppet versions
* Puppet >= 3

### Supported OS
* darwin osfamily



## Usage Example

```puppet
    macfirewall { '/System/Library/CoreServices/RemoteManagement/ARDAgent.app':
                  ensure => 'present',
                  access => 'permitted',
                }
```
###### Using as a resource:
```
sudo puppet resource macfirewall
```

## Parameters

* `ensure`: This specifies if the application/binary is present or absent on the firewall.

    * 'present': application/binary is added to the firewall config.
    * 'absent': application/binary is removed to the firewall config.  


* `access`: This specifies is the application/binary is allowed or blocked on the Firewall.

  * 'permitted': application/binary is allowed through the firewall.
  * 'blocked': application/binary is blocked on the firewall.


## Limitations

* This module does not manage the set the global state of the Application Firewall.
* This module does not manage pf firewall.
