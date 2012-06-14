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

Carbon
------

Carbon endpoints can be controlled using osops endpoints.  See osops-utils
for examples.

Overridable endpoints:

Line receiver -- what port and ip the line receiver endpoint listens to

 * node["carbon"]["services"]["line-reciever"]["port"] (default 2003)
 * node["carbon"]["services"]["line-receiver"]["network"] (default "management")

Pickle receiver -- what port and ip the pickle receiver endpoint listens to

 * node["carbon"]["services"]["pickle-reciever"]["port"] (default 2004)
 * node["carbon"]["services"]["pickle-receiver"]["network"] (default "management")

Cache query -- what port and ip the cache-query interface listens to

 * node["carbon"]["services"]["cache-query"]["port"] (default 7002)
 * node["carbon"]["services"]["cache-query"]["network"] (default "management")

Usage
=====

recipe[graphite::carbon] will install a carbon-cache node
recipe[graphite::graphite] will install the graphite web dashboard
