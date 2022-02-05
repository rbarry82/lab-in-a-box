### BIND configuration

An as-is, working configuration for BIND9, but it's BIND. This was initially used against BIND7, but zonefiles are zonefiles. BIND is the reference server, so the risk of breakage is low.

Substitute your domain information where appropriate.

Paths for `/var/named` are because I chroot `named` just in case. Again, lots of distros have a package which does this automatically. If yours doesn't or you don't want to, just point it to `/etc/named` instead.

As a default, `internal.priv` is not publicly routable, and new hosts which dynamically provision records from DHCP will go there. `example.org` is public, and only has records here if you want to go the split-horizon route and make `example.org` records which aren't visible from anywhere else in the world (you can also do this to override "public" websites to poison users if you want to), and the zonefiles are there purely for `DNAME` redirects so `letsencrypt` certs for Kubernetes don't fail validation.

There's a redirecting `example.org` subdomain for `home.example.org` which pushes this, so you aren't tempted to pollute public records, and `gateway.home.example.org -> gateway.internal.priv`

If you follow the `external-dns` kubernetes configuration, new services/ingresses there will get DNS records, and they'll be resolveable from both.

Creating a `test` ingress will create `test.k8s.internal.priv`, which will transparently resolve to `test.k8s.example.org` without breaking the certificate.

If you've never used BIND, the zonefiles are serialized. If it's running and you want to edit records, run `rndc -k /path/to/key freeze`, and `rndc -k /path/to/key thaw` when you're done. 

It's easiest if this key is the same one you share with `dhcpd`, but you don't have to.

The `os-internal.zone` forwards to Designate in an openstack instance. It's a reasonable example of a forwarder, and it's here because "how do I delegate to a server on a non-standard port" is hard.
