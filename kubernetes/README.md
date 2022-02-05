### Kubernetes manifests

Some plain k8s manifests, some helm chart values. 

Install helm! 

Helm chart values have `-values` in the filename, and can be applied, generally, with the "obvious" helm chart for each.

`letsencrypt` and `external-dns` have defaults for Cloudflare DNS and BIND9, respectively. Add your auth config for `letsencrypt`, and tweak the values in `external-dns`.

Certificate population relies on `kubed` to put the wildcard in different namespaces. If you don't care about public DNS records, just get `letsencrypt` to issue one for every hostname. If you want to keep a wildcard in secrets for one namespace and copy it to others for DNS `DNAME` work, use that.

All ingresses are configured twice. This looks strange, and you may not need it, but it's here for the DNS `DNAME` trickery, so `https` traffic and `http` traffic go to the same service through different routes, one of which uses the `example.org` domain with working SSL, and one is internal where I don't care.

You probably don't need the `unifi` stuff either, but it's here as an easy-to-find example for "how do I map a new LB port to a service with a bunch of weird ports and still get DNS records".
