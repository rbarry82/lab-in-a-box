## Provision machines

This repository contains both my [configs/dotfiles](./dots) and some associated Ansible [Roles](./roles) to set up machines of various types.

### What does this do?

- Download and install Ansible
- Fetch any roles required from Ansible Galaxy
- Provision the host according to any tags set

### How do I use it

Take an existing Ansible inventory file, or make one. It can be as simple as:

```toml
[hosts]
127.0.0.1
10.0.0.2
```

You should already have SSH keys set up for your user, and passwordless sudo. If you don't, run

```bash
ansible-playbook -i inventory.bootstrap bootstrap.yaml
```

`./install.sh <inventory> --all # or some other tags instead of --all`

Default assumes server, no desktop tweaking/packages.

### What do the roles do?

There are README files for each of the Roles. They should answer any questions...
