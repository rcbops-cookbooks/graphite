# FIXME: right now, the statsd network is ignored -- the statsd-c implementation
# we're using binds 0.0.0.0.
default["statsd"]["flush_interval"] = 60
default["statsd"]["services"]["statsd"]["port"] = 8125
default["statsd"]["services"]["statsd"]["network"] = "management"

default["graphite"]["services"]["api"]["port"] = 80
default["graphite"]["services"]["api"]["network"] = "public"

default["carbon"]["services"]["line-receiver"]["port"] = 2003
default["carbon"]["services"]["line-receiver"]["network"] = "management"

default["carbon"]["services"]["pickle-receiver"]["port"] = 2004
default["carbon"]["services"]["pickle-receiver"]["network"] = "management"

default["carbon"]["services"]["cache-query"]["port"] = 7002
default["carbon"]["services"]["cache-query"]["network"] = "management"

case platform
when "fedora"
  default["graphite"]["platform"] = {
    "carbon_packages" => ["carbon"],
    "carbon_service" => "carbon-cache",
    "carbon_config_source" => "carbon.conf.redhat.erb",
    "carbon_config_dest" => "/etc/graphite/carbon.conf",
    "carbon_schema_config" => "/etc/graphite/storage-schemas.conf",
    "whisper_packages" => ["whisper"],
    "graphite_packages" => ["graphite-web", "mod_python"],
    "package_overrides" => "",
    "carbon_apache_user" => "apache",
    "carbon_conf_dir" => "/etc/graphite",
    "statsd_service" => "statsd-c",
    "statsd_template" => "/etc/statsd-c/config"
  }
when "ubuntu"
  default["graphite"]["platform"] = {
    "carbon_packages" =>["python-carbon"],
    "carbon_service" => "carbon-cache",
    "carbon_schema_config" => "/etc/carbon/storage-schemas.conf",
    "carbon_config_source" => "",
    "carbon_config_dest" => "/etc/carbon/carbon.conf",
    "whisper_packages" => ["python-whisper"],
    "graphite_packages" => ["graphite"],
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'",
    "carbon_apache_user" => "www-data",
    "carbon_conf_dir" => "/etc/carbon",
    "statsd_service" => "statsd",
    "statsd_template" => "/etc/default/statsd"
  }
end
