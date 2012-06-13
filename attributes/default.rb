case platform
when "fedora"
  default["graphite"]["platform"] = {
    "carbon_packages" => ["graphite-web"],
    "carbon_service" => "graphite-web",
    "whisper_packages" => ["whisper"],
    "graphite_packages" => ["graphite-web"],
    "package_overrides" => ""
  }
when "ubuntu"
  default["graphite"]["platform"] = {
    "carbon_packages" =>["python-carbon"],
    "carbon_service" => "carbon-cache",
    "whisper_packages" => ["python-whisper"],
    "graphite_packages" => ["graphite"],
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'",
  }
end
