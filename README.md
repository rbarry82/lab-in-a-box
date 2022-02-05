# lab-in-a-box
Configs to make a production-like network.

See the relevant folders for configuring DHCP, DNS, and deploying Kubernetes stuff for monitoring+storage+metallb+traefik.

If you want to run this in libvirt, make a new network and `virsh net-edit foo`, then remove the `<dhcp>` section under `<ip>`.

Provision your first system as the DNS+DHCP server. FreeBSD or some very lightweight distro is fine. DHCP+dns don't take much. Give it a static address, configure `resolv.conf` by hand, and once the services start, additional VMs will accept DHCP offers from it and work as "normal".

The range here does not match the range in `dhcp` or the `metallb` configuration. I don't know what you're going to pick, but make sure they line up.

```xml
<network connections='1'>
  <name>nodhcp</name>
  <uuid>f3ead677-618b-4cf7-b9ff-38b4185c80b9</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:29:61:84'/>
  <ip address='192.168.122.1' netmask='255.255.252.0'>
  </ip>
</network>
```
