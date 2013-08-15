Support
=======

Issues have been disabled for this repository.  
Any issues with this cookbook should be raised here:

[https://github.com/rcbops/chef-cookbooks/issues](https://github.com/rcbops/chef-cookbooks/issues)

Please title the issue as follows:

[graphite]: \<short description of problem\>

In the issue description, please include a longer description of the issue, along with any relevant log/command/error output.  
If logfiles are extremely long, please place the relevant portion into the issue description, and link to a gist containing the entire logfile

Please see the [contribution guidelines](CONTRIBUTING.md) for more information about contributing to this cookbook.

Description
===========

Installs and configures graphite and associated components

http://graphite.wikidot.com/

Packages are installed from the OSOps team PPA:

https://launchpad.net/~osops-packaging/+archive/ppa

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use)

Platform
--------

* CentOS >= 6.3
* Ubuntu >= 12.04

Cookbooks
---------

The following cookbooks are dependencies:

* apache2
* osops-utils

Attributes
==========

* `statsd["flush_interval"]` - How often to aggregate stats and send to graphite (seconds)
* `statsd["services"]["statsd"]["port"]` - Port
* `statsd["services"]["statsd"]["network"]` - `osops_networks` network name which service operates on

* `graphite["services"]["api"]["port"]` - Port
* `graphite["services"]["api"]["network"]` - `osops_networks` network name which service operates on

* `carbon["services"]["line-receiver"]["port"]` - Port
* `carbon["services"]["line-receiver"]["network"]` - `osops_networks` network name which service operates on

* `carbon["services"]["pickle-receiver"]["port"]` - Port
* `carbon["services"]["pickle-receiver"]["network"]` - `osops_networks` network name which service operates on

* `carbon["services"]["cache-query"]["port"]` - Port
* `carbon["services"]["cache-query"]["network"]` - `osops_networks` network name which service operates on

* `carbon["storage_schemas"]` - Hash for storage schema options

* `graphite["platform"]` - Hash of platform specific package/service names and options

Usage
=====

* recipe[graphite::carbon] will install carbon-cache
* recipe[graphite::graphite] will install the graphite web dashboard
* recipe[graphite::statsd] will install statsd
* recipe[graphite::whisper] will install the whisper database

License and Author
==================

Author:: Justin Shepherd (<justin.shepherd@rackspace.com>)  
Author:: Jason Cannavale (<jason.cannavale@rackspace.com>)  
Author:: Ron Pedde (<ron.pedde@rackspace.com>)  
Author:: Joseph Breu (<joseph.breu@rackspace.com>)  
Author:: William Kelly (<william.kelly@rackspace.com>)  
Author:: Darren Birkett (<darren.birkett@rackspace.co.uk>)  
Author:: Evan Callicoat (<evan.callicoat@rackspace.com>)  
Author:: Matt Thompson (<matt.thompson@rackspace.co.uk>)  

Copyright 2012-2013, Rackspace US, Inc.  

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
