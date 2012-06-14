maintainer       "Rackspace Hosting"
maintainer_email "osops@lists.launchpad.net"
license          "Apache 2.0"
description      "Installs/Configures graphite"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%W{apt apache2 osops-utils}.each do |dep|
  depends dep
end

%W{ubuntu}.each do |distro|
  supports distro
end
