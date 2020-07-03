require "json"
require "memoist"

module GcpData
  class Error < StandardError; end
  extend Memoist

  def project
    ENV['GOOGLE_PROJECT'] || creds("project_id") || gcloud_config("core/project") || raise("Unable to look up google project_id")
  end
  memoize :project

  def region
    ENV['GOOGLE_REGION'] || gcloud_config("compute/region") || 'us-central1'
  end
  memoize :region

  def zone
    ENV['GOOGLE_ZONE'] || gcloud_config("compute/zone") || 'us-central1a'
  end
  memoize :zone

  def creds(name)
    credentials[name] if credentials
  end

  def credentials
    path = ENV['GOOGLE_APPLICATION_CREDENTIALS']
    JSON.load(IO.read(path)) if path && File.exist?(path)
  end
  memoize :credentials

  def gcloud_config(key)
    check_gcloud_installed!
    val = `gcloud config get-value #{key}`.strip
    val unless val == ''
  end

  def check_gcloud_installed!
    installed = system("type gcloud > /dev/null 2>&1")
    return if installed
    raise Error.new("ERROR: gcloud is not installed. Please install the gcloud command.")
  end

  extend self
end
