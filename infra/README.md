# Infrastructure

This is where all of the infrastructure related code is located. We are using Ansible which is the right mix of automation and easy of use for our needs.

## Get Started

1. Install Python 3 (Latest version is fine)
2. Run `./scripts/setup.sh` which will configure your local machine to run using our configuration.
    Namely it will create a python venv so we can manage package versions independently of the system configuration. It will also install the correct version of Ansible and a few other useful tools.
3. Run `source virtual_enviroment/bin/activate` from the `infra` folder to enter the development environment.
    **Run `deactivate` when you are done to leave the dev environment.**


## Ethan's Temporary Link Holding

These are links that I will be looking into more, but just want to put here for reference

Security/configuration:
- https://www.redhat.com/sysadmin/ansible-playbooks-secrets
- https://github.com/geerlingguy/ansible-for-devops
- https://github.com/geerlingguy/ansible-for-devops/tree/master/security
- https://github.com/dev-sec/ansible-collection-hardening
- https://github.com/geerlingguy/ansible-role-nginx


Other:
- Simple Nginx play - https://gist.github.com/jvns/06754e9e65b49dd461fefa071dd4aace
- MySQL role - https://gist.github.com/ihassin/8106956
- Testing w/ Molecule, apparently officially supported - https://molecule.readthedocs.io/en/latest/index.html
- Testing Ansible w/ Docker - [First one](https://www.ansible.com/blog/testing-ansible-roles-with-docker), [Second one](https://github.com/chrismeyersfsu/role-iptables/tree/master/test)
- Testing Ansible w/ test-kitchen - [First one](https://github.com/neillturner/kitchen-ansible), [Second one](https://www.digitalocean.com/community/tutorials/how-to-test-your-ansible-deployment-with-inspec-and-kitchen)



# How to use Ansible
Mostly copied from https://github.com/acch/ansible-boilerplate

## Using Ansible

Install `ansible` on your laptop and link the `hosts` file from `/etc/ansible/hosts` to the file in your repository. Now you're all set.

To run a single (ad-hoc) task on multiple servers:

```
# Check connectivity
ansible all -m ping -u root

# Run single command on all servers
ansible all -m command -a "cat /etc/hosts" -u root

# Run single command only on servers in specific group
ansible anygroup -m command -a "cat /etc/hosts" -u root

# Run single command on individual server
ansible server1 -m command -a "cat /etc/hosts" -u root
```

As the `command` module is the default, it can also be omitted:

```
ansible server1 -a "cat /etc/hosts" -u root
```

To use shell variables on the remote server, use the `shell` module instead of `command`, and use single quotes for the argument:

```
ansible server1 -m shell -a 'echo $HOSTNAME' -u root
```

The true power of ansible comes with so called *playbooks* &mdash; think of them as scripts, but they're declarative. Playbooks allow for running multiple tasks on any number of servers, as defined in the configuration files (`*.yml`):

```
# Run all tasks on all servers
ansible-playbook site.yml -v

# Run all tasks only on group of servers
ansible-playbook anygroup.yml -v

# Run all tasks only on individual server
ansible-playbook site.yml -v -l server1
```

Note that `-v` produces verbose output. `-vv` and `-vvv` are also available for even more (debug) output.

To verify what tasks would do without changing the actual configuration, use the `--list-hosts` and `--check` parameters:

```
# Show hosts that would be affected by playbook
ansible-playbook site.yml --list-hosts

# Perform dry-run to see what tasks would do
ansible-playbook site.yml -v --check
```

Running all tasks in a playbook may take a long time. *Tags* are available to organize tasks so one can only run specific tasks to configure a certain component:

```
# Show list of available tags
ansible-playbook site.yml --list-tags

# Only run tasks required to configure DNS
ansible-playbook site.yml -v -t dns
```

Note that the above command requires you to have tasks defined with the `tags: dns` attribute.

## Configuration files

The `hosts` file defines all hosts and groups which they belong to. Note that a single host can be member of multiple groups. Define groups for each rack, for each network, or for each environment (e.g. production vs. test).

### Playbooks

Playbooks associate hosts (groups) with roles. Define a separate playbook for each of your groups, and then import all playbooks in the main `site.yml` playbook.

File | Description
---- | -----------
`site.yml` | Main playbook - runs all tasks on all servers
`anygroup.yml` | Group playbook - runs all tasks on servers in group *anygroup*

### Roles

The group playbooks (e.g. `anygroup.yml`) simply associate hosts with roles. Actual tasks are defined in these roles:

```
roles/
├── common/             Applied to all servers
│   ├── handlers/
│   ├── tasks/
│   │   └ main.yml      Tasks for all servers
│   └── templates/
└── anyrole/            Applied to servers in specific group(s)
    ├── handlers/
    ├── tasks/
    │   └ main.yml      Tasks for specific group(s)
    └── templates/
```

Consider adding separate roles for different applications (e.g. webservers, dbservers, hypervisors, etc.), or for different responsibilities which servers fulfill (e.g. infra_server vs. infra_client).

### Tags

Use the following command to show a list of available tags:

```
ansible-playbook site.yml --list-tags
```

Consider adding tags for individual components (e.g. DNS, NTP, HTTP, etc.).

Role | Tags
--- | ---
Common | all,check

## Copyright and license

Copyright 2017 Achim Christ, released under the [MIT license](LICENSE)
