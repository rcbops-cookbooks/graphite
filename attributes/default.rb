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
    "package_overrides" => ""
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
  }
end

default["carbon"]["services"]["line-receiver"]["port"] = 2003
default["carbon"]["services"]["line-receiver"]["network"] = "management"

default["carbon"]["services"]["pickle-receiver"]["port"] = 2004
default["carbon"]["services"]["pickle-receiver"]["network"] = "management"

default["carbon"]["services"]["cache-query"]["port"] = 7002
default["carbon"]["services"]["cache-query"]["network"] = "management"
