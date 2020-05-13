require "memoist"

module GcpData
  class Error < StandardError; end
  extend Memoist

  def project
    gcloud_config("core/project")
  end
  memoize :project

  def region
    gcloud_config("compute/region")
  end
  memoize :region

  def gcloud_config(key)
    check_gcloud_installed!
    `gcloud config get-value #{key}`.strip
  end

  def check_gcloud_installed!
    installed = system("type gcloud > /dev/null 2>&1")
    return if installed
    raise Error.new("ERROR: gcloud is not installed. Please install the gcloud command.")
  end

  extend self
end
