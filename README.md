Description
===========

Installs and configures graphite (http://graphite.wikidot.com/) and associated components.

Packages are installed from the OSOps team PPA:

https://launchpad.net/~osops-packaging/+archive/ppa

Requirements
============

Ubuntu 12.04 (Precise)

Opscode "apt" cookbook

Attributes
==========

node[:graphite][:password] sets the default graphite root password, otherwise a
random password will be assigned

Usage
=====

recipe[graphite::carbon] will install a carbon-cache node
recipe[graphite::graphite] will install the graphite web dashboard

