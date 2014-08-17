# puppet-icinga2

## About

This module installs and configures the [Icinga 2 monitoring system](https://www.icinga.org/icinga2/). It can also install and configure [NRPE](http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details) on client systems that are being monitored by an Icinga 2 server. 

The module has only been tested on [CentOS 6.5](http://www.centos.org/download/) and Ubuntu [12.04](http://releases.ubuntu.com/12.04/) and [14.04](http://releases.ubuntu.com/14.04/). Red Hat and other EL derivatives, like Fedora, should work, but have not been tested.

Currently, this module does not install or configure any web UIs for Icinga 2. This module also does not install or configure a mail transfer agent (MTA) to send outgoing alert emails.

While NRPE is required for Icinga 2 to check non-network-reachble things on client machines (CPU, load average, etc.), this module itself doesn't have any dependencies between the server component (the `icinga2::server` class) and client component (the `icinga2::nrpe` class). Either one can be used independently of the other.

## Installation

Check [doc/installation.md](doc/installation.md) for a detailed introduction.


## Documentation

The documentation is located in the doc/ directory. The latest documentation
is also available on https://docs.icinga.org

## Support

Check the project website at http://www.icinga.org for status updates and
https://support.icinga.org if you want to contact us.
