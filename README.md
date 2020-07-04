# GcpData

Simple library to get current gcp data like project and region.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gcp_data'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gcp_data

This library can rely on the `gcloud` command, so it should be installed.

## Usage

```ruby
GcpData.project
GcpData.region
```

## Precedence

This library will return prjoect and region info using different sources with this precedence:

1. Environment variables: GOOGLE_PROJECT, GOOGLE_REGION, GOOGLE_ZONE
2. Google Credentials file: only project id available from the GOOGLE\_APPLICATION_CREDENTIALS file
3. CLI: gcloud: project, region, and zone available
4. Defaults: region=us-central1 and zone==us-central1a

### 1. Environment variables

The environment variables take the highest precedence: GOOGLE_PROJECT, GOOGLE_REGION, GOOGLE_ZONE

### 2. Google credentials file

You can also authenticate to the Google API by setting a GOOGLE\_APPLICATION_CREDENTIALS env var that points to file a JSON file on your system. Example: `GOOGLE_APPLICATION_CREDENTIALS=~/.gcp/credentials.json`. More info at google docs: [Getting Started with Authentication](https://cloud.google.com/docs/authentication/getting-started).

This file contains a project_id key. So if you have set the GOOGLE\_APPLICATION_CREDENTIALS and not set the GOOGLE_PROJECT var, then this library will use the project_id from the GOOGLE\_APPLICATION_CREDENTIALS file.

### 3. CLI: gcloud

The gcloud cli can also be used to set and get google project and region info. Here's a cheatsheet of the commands:

    gcloud config list
    gcloud config set project project-123
    gcloud config set compute/region us-central1
    gcloud config set compute/zone us-central1-b

The commands saves to a file in ~/.config/gcloud. The file looks something like this:

~/.config/gcloud/configurations/config_default

    [core]
    project = project-12345

    [compute]
    region = us-central1
    zone   = us-central1-a

### 4. Defaults

The library will fallback to default values when it's unable to lookup the region and zone. The default values are:

    region=us-central1
    zone==us-central1a

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tongueroo/gcp_data.
