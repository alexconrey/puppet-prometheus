# Class: prometheus
#
# This module manages prometheus
#
# Parameters:
#
#  [*configname*]
#  the name of the configfile, defaults to prometheus.yaml or prometheus.yml on most operating systems
#
#  [*manage_user*]
#  Whether to create user for prometheus or rely on external code for that
#
#  [*user*]
#  User running prometheus
#
#  [*manage_group*]
#  Whether to create user for prometheus or rely on external code for that
#
#  [*purge_config_dir*]
#  Purge config files no longer generated by Puppet
#
#  [*group*]
#  Group under which prometheus is running
#
#  [*bin_dir*]
#  Directory where binaries are located
#
#  [*shared_dir*]
#  Directory where shared files are located
#
#  [*arch*]
#  Architecture (amd64 or i386)
#
#  [*version*]
#  Prometheus release
#
#  [*install_method*]
#  Installation method: url or package (only url is supported currently)
#
#  [*os*]
#  Operating system (linux is supported)
#
#  [*download_url*]
#  Complete URL corresponding to the Prometheus release, default to undef
#
#  [*download_url_base*]
#  Base URL for prometheus
#
#  [*download_extension*]
#  Extension of Prometheus binaries archive
#
#  [*package_name*]
#  Prometheus package name - not available yet
#
#  [*package_ensure*]
#  If package, then use this for package ensurel default 'latest'
#
#  [*config_dir*]
#  Prometheus configuration directory (default /etc/prometheus)
#
#  [*localstorage*]
#  Location of prometheus local storage (storage.local argument)
#
#  [*extra_options*]
#  Extra options added to prometheus startup command
#
#  [*config_hash*]
#  Startup config hash
#
#  [*config_defaults*]
#  Startup config defaults
#
#  [*config_template*]
#  Configuration template to use (template/prometheus.yaml.erb)
#
#  [*config_mode*]
#  Configuration file mode (default 0660)
#
#  [*service_enable*]
#  Whether to enable or not prometheus service from puppet (default true)
#
#  [*service_ensure*]
#  State ensured from prometheus service (default 'running')
#
#  [*manage_service*]
#  Should puppet manage the prometheus service? (default true)
#
#  [*restart_on_change*]
#  Should puppet restart prometheus on configuration change? (default true)
#  Note: this applies only to command-line options changes. Configuration
#  options are always *reloaded* without restarting.
#
#  [*init_style*]
#  Service startup scripts style (e.g. rc, upstart or systemd)
#
#  [*global_config*]
#  Prometheus global configuration variables
#
#  [*rule_files*]
#  Prometheus rule files
#
#  [*scrape_configs*]
#  Prometheus scrape configs
#
#  [*remote_read_configs*]
#  Prometheus remote_read config to scrape prometheus 1.8+ instances
#
#  [*remote_write_configs*]
#  Prometheus remote_write config to scrape prometheus 1.8+ instances
#
#  [*alerts*]
#  alert rules to put in alerts.rules
#
#  [*extra_alerts*]
#  Hash with extra alert rules to put in separate files.
#
#  [*alert_relabel_config*]
#  Prometheus alert relabel config under alerting
#
#  [*alertmanagers_config*]
#  Prometheus managers config under alerting
#
#  [*storage_retention*]
#  How long to keep timeseries data. This is given as a duration like "100h" or "14d". Until
#  prometheus 1.8.*, only durations understood by golang's time.ParseDuration are supported. Starting
#  with prometheus 2, durations can also be given in days, weeks and years.
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class prometheus (
  String $configname,
  String $user,
  String $group,
  Array $extra_groups,
  Variant[Prometheus::Absolutepath, String] $bin_dir,
  Variant[Prometheus::Absolutepath, String] $shared_dir,
  String $version,
  String $install_method,
  Variant[Prometheus::HTTPUrl, Prometheus::HTTPSUrl] $download_url_base,
  String $download_extension,
  String $package_name,
  String $package_ensure,
  String $config_dir,
  Variant[Prometheus::Absolutepath, String] $localstorage,
  String $config_template,
  String $config_mode,
  Hash $global_config,
  Array $rule_files,
  Array $scrape_configs,
  Array $remote_read_configs,
  Array $remote_write_configs,
  Variant[Array,Hash] $alerts,
  Array $alert_relabel_config,
  Array $alertmanagers_config,
  String $storage_retention,
  Variant[Prometheus::Absolutepath, String] $env_file_path,
  Boolean $manage_prometheus_server,
  Boolean $service_enable,
  String $service_ensure,
  Boolean $manage_service,
  Boolean $restart_on_change,
  String $init_style,
  String $extra_options,
  Optional[String] $download_url,
  String $arch,
  Boolean $manage_group,
  Boolean $purge_config_dir,
  Boolean $manage_user,
  Hash $extra_alerts    = {},
  Hash $config_hash     = {},
  Hash $config_defaults = {},
  String $os            = downcase($facts['kernel']),
) {

  case $arch {
    'x86_64', 'amd64': { $real_arch = 'amd64' }
    'i386':            { $real_arch = '386'   }
    default:           {
      fail("Unsupported kernel architecture: ${arch}")
    }
  }

  if $manage_prometheus_server {
    include prometheus::server
  }
}
