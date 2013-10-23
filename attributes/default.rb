# FIXME: right now, the statsd network is ignored -- the statsd-c implementation
# we're using binds 0.0.0.0.
default["statsd"]["flush_interval"] = 60                                    # node_attribute
default["statsd"]["services"]["statsd"]["port"] = 8125                      # node_attribute
default["statsd"]["services"]["statsd"]["network"] = "management"           # node_attribute

default["graphite"]["services"]["api"]["port"] = 80                         # node_attribute
default["graphite"]["services"]["api"]["network"] = "management"                # node_attribute

default["carbon"]["services"]["line-receiver"]["port"] = 2003               # node_attribute
default["carbon"]["services"]["line-receiver"]["network"] = "management"    # node_attribute

default["carbon"]["services"]["pickle-receiver"]["port"] = 2004             # node_attribute
default["carbon"]["services"]["pickle-receiver"]["network"] = "management"  # node_attribute

default["carbon"]["services"]["cache-query"]["port"] = 7002                 # node_attribute
default["carbon"]["services"]["cache-query"]["network"] = "management"      # node_attribute

default["carbon"]["storage_schemas"] = {
  "everything_1min_1day" => {
    "priority" => "100",
    "pattern" => ".*",
    "retentions" => "60:1440"
  }
}

case platform
when "redhat", "centos", "fedora"
  default["graphite"]["platform"] = {                                                   # node_attribute
    "carbon_packages" => ["carbon"],                                        # node_attribute
    "carbon_apache_user" => "apache",                                       # node_attribute
    "carbon_conf_dir" => "/opt/graphite/conf",                              # node_attribute
    "carbon_log_dir" => "/var/log/carbon/carbon",                           # node_attribute
    "graphite_packages" => ["bitmap", "bitmap-fonts-compat", "pycairo",            # node_attribute
      "Django14", "django-tagging", "graphite-web", "mod_python"],
    "graphite_pythonpath" => "/opt/graphite/webapp",
    "graphite_root" => "/opt/graphite",                                     # node_attribute
    "graphite_log_dir" => "/opt/graphite/storage/log/webapp",               # node_attribute
    "whisper_packages" => ["whisper"],                                      # node_attribute
    "statsd_service" => "statsd-c",                                         # node_attribute
    "statsd_template" => "/etc/statsd-c/config",                            # node_attribute
    "package_options" => ""                                               # node_attribute
  }
when "ubuntu"
  default["graphite"]["platform"] = {
    "carbon_packages" => ["python-carbon"],                                 # node_attribute
    "carbon_apache_user" => "www-data",                                     # node_attribute
    "carbon_conf_dir" => "/etc/carbon",                                     # node_attribute
    "carbon_log_dir" => "/var/log/carbon/carbon",                           # node_attribute
    "graphite_packages" => ["python-cairo", "graphite"],                     # node_attribute
    "graphite_pythonpath" => "/usr/share/graphite/webapp",                  # node_attribute
    "graphite_root" => "/var/lib/graphite",                                 # node_attribute
    "graphite_log_dir" => "/var/lib/graphite/storage/log/webapp",           # node_attribute
    "whisper_packages" => ["python-whisper"],                               # node_attribute
    "statsd_service" => "statsd",                                           # node_attribute
    "statsd_template" => "/etc/default/statsd",                             # node_attribute
    "package_options" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'" # node_attribute
  }
end
