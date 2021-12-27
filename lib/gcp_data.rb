require "json"
require "memoist"

module GcpData
  class Error < StandardError; end
  extend Memoist

  def project
    ENV['GOOGLE_PROJECT'] || gcloud_config("core/project") || creds("project_id") || raise("Unable to look up google project_id")
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
    if gcloud_installed?
      # redirect stderr to stdout because (unset) is printed to stderr when a value is not set. IE:
      #
      #   $ gcloud config get-value compute/region
      #   (unset)
      #
      command = "gcloud config get-value #{key} 2>&1"
      puts "RUNNING: #{command}" if ENV['GCP_DATA_DEBUG']
      val = `#{command}`.strip
      val unless ['', '(unset)'].include?(val)
    else
      unless env_vars_set?
        error_message
      end
    end
  end

  def gcloud_installed?
    system("type gcloud > /dev/null 2>&1")
  end

  def env_vars
    %w[
      GOOGLE_APPLICATION_CREDENTIALS
      GOOGLE_PROJECT
      GOOGLE_REGION
    ]
  end

  def env_vars_set?
    env_vars.all? { |var| ENV[var] }
  end

  def error_message(message=nil)
    all_vars = format_list(env_vars)
    unset_vars = format_list(env_vars.reject { |var| ENV[var] })
    message ||= <<~EOL
      ERROR: gcloud is not installed. Please install the gcloud CLI and configure it.
      GcpData uses it to detect google cloud project, region, zone.

      You can also configure these environment variables instead of installing the google CLI.

      #{all_vars}

      Currently, the unset vars are:

      #{unset_vars}

    EOL
    show_error(message)
  end

  def show_error(message)
    if ENV['GCP_DATA_RAISE_ERROR']
      raise Error.new(message)
    else
      puts message
      exit 1
    end
  end

  def format_list(vars)
    vars.map { |var| "    #{var}" }.join("\n")
  end

  extend self
end
