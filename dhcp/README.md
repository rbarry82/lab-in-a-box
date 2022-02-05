### DHCP configuration

An as-is, working configuration for `isc-dhcpd`.

`rndc-key` should come from BIND. Some distros automatically create it. Some do not. If it doesn't, run `rndc-confgen -a -b 512 -k /tmp/rndc-key` so you don't clobber the existing file, and use it here. `rndc*` is generally part of the `bind-utils` or similar.

> ### DANGER
>
> This `dhcpd` configuration is presumed to be authoritative. It **will** respond to DHCP requests on whatever network you provision it on. Be careful with routers. Disable the router's DHCP (I have for many years), use a second NIC, put it on a VLAN without a relay, put it in a VM network with `dnsmasq` turned off (libvirt).
>

This DHCP server will issue addresses in `192.168.0.0./22`, with the assumption that `metallb` will be `192.168.3.0/24`, a DNS server at `192.168.0.2` and `192.168.0.3`, and a gateway at `192.168.0.1`. Adjust as needed.

An example of a static reservation is present, as well as a hole-punch (a range which stops in the middle then restarts) in case you already have some system which has an IP which is more or less static and you want to leave it there, just with a new reservation. Otherwise, trying to reserve an IP in the dynamic range will not parse.

Lots of options are set here which you may not need. OMAPI is enable for IPAM systems, a failover server is configured if you want to set one up to test it. iPXE options are set, and a boot server which presents a menu from a PHP script is present. If you want to set one up, configuring TFTP for PXE is well-documented (and using iPXE with HTTP behind that is very strongly recommended -- TFTP is pretty slow for pushing 'big' images on modern systems)

By default, iPXE EFI chainloading will be performed to ensure that PXE booted EFI systems are "really" in EFI mode. EFI PXE uses `grub2`, with the normal `grub2` syntax, so no need to go learn all about the old list files.

If you're running this in VMs, make sure you have the appropriate EDK2 packages installed, that your VM is configured with Q35+UEFI, and you're off to the races.
