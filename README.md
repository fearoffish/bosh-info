# Bosh::Info

This is a simple little gem for now, banged together just to get some useful information between cf-releases. It could be so much more.

## Installation

Install from rubygems:

    $ gem install bosh-info

## Usage

It only does one thing for now, and that's show differences between releases. Specifically property changes in spec files.

Example:

```
$ bosh-info specs --from v134 --to v138 --cf-release /a/fearoffish/cf-release
------------------------------------
Job: cloud_controller_ng
Removed:

---
packages:
- ruby_next
properties:
  vcap_redis.address:
    description: deprecated
  vcap_redis.port:
    description: deprecated
  vcap_redis.password:
    description: deprecated
  ccng.cc_partition:
    default: default
  ccng.use_nginx:
    default: 'true'

Added:

---
packages:
- ruby
properties:
  api_version:
    default: 2.0.0
    description:
  ccng.tasks_disabled:
    default: false
    description: Disable tasks endpoint
  name:
    default: vcap
  build:
    default: '2222'
  version:
    default: '2'
  support_address:
    default: http://support.cloudfoundry.com
  description:
    default: Cloud Foundry sponsored by Pivotal
  ccng.cc_partition:
    default: ng
  ccng.use_nginx:
    default: true
  ccdb_ng.max_connections:
    default: 32
  ccdb_ng.pool_timeout:
    default: 10
  login.enabled:
    default: true

------------------------------------
Job: collector
Removed:

--- {}

Added:

---
properties:
  collector.intervals.discover:
    description: the interval in seconds that the collector attempts to discover components
    default: 60
  collector.intervals.healthz:
    description: the interval in seconds that healthz is checked
    default: 30
  collector.intervals.local_metrics:
    description: the interval in seconds that local_metrics are checked
    default: 30
  collector.intervals.nats_ping:
    description: the interval in seconds that the collector pings nats to record latency
    default: 30
  collector.intervals.prune:
    description: the interval in seconds that the collector attempts to prune unresponsive
      components
    default: 300
  collector.intervals.varz:
    description: the interval in seconds that varz is checked
    default: 30

------------------------------------
Job: dea_logging_agent
Removed:

--- {}

Added:

---
name: dea_logging_agent
templates:
  dea_logging_agent_ctl.erb: bin/dea_logging_agent_ctl
  dea_logging_agent.json.erb: config/dea_logging_agent.json
packages:
- common
- dea_logging_agent
properties:
  loggregator.debug:
    description: boolean value to turn on verbose logging for loggregator system (dea
      agent & loggregator server)
    default: false
  loggregator.server:
    description: loggregator server in host:port format
  loggregator.status.user:
    description: username used to log into varz endpoint
  loggregator.status.password:
    description: password used to log into varz endpoint
  loggregator.status.port:
    description: port used to run the varz endpoint
  nats.user:
    description: Username for cc client to connect to NATS
  nats.password:
    description: Password for cc client to connect to NATS
  nats.address:
    description: IP address of Cloud Foundry NATS server
  nats.port:
    description: IP port of Cloud Foundry NATS server

------------------------------------
Job: dea_next
Removed:

---
packages:
- ruby_next
- imagemagick

Added:

---
packages:
- ruby
properties:
  dea_next.directory_server_protocol:
    description: The protocol to use when communicating with the directory server
      ("http" or "https")
    default: https
  dea_next.kernel_network_tuning_enabled:
    description: with latest kernel version, no kernel network tunings allowed with
      in warden cpi containers
    default: true
  disk_quota_enabled:
    description: disk quota must be disabled to use warden-inside-warden with the
      warden cpi
    default: true
  syslog_aggregator:
    description: Syslog aggregator stuff
  dea_next.stacks:
    default:
    - lucid64

------------------------------------
Job: health_manager_next
Removed:

---
packages:
- ruby_next

Added:

---
packages:
- ruby

------------------------------------
Job: loggregator
Removed:

--- {}

Added:

---
name: loggregator
templates:
  loggregator_ctl.erb: bin/loggregator_ctl
  loggregator.json.erb: config/loggregator.json
  uaa_token.pub.erb: config/uaa_token.pub
packages:
- common
- loggregator
properties:
  loggregator.debug:
    description: boolean value to turn on verbose logging for loggregator system (dea
      agent & loggregator server)
    default: false
  loggregator.status.user:
    description: username used to log into varz endpoint
  loggregator.status.password:
    description: password used to log into varz endpoint
  loggregator.status.port:
    description: port used to run the varz endpoint
  loggregator.maxRetainedLogMessages:
    description: number of log messages to retain per application
    default: 10
  cc.srv_api_uri:
    description: API URI of cloud controller
  nats.user:
    description: Username for cc client to connect to NATS
  nats.password:
    description: Password for cc client to connect to NATS
  nats.address:
    description: IP address of Cloud Foundry NATS server
  nats.port:
    description: IP port of Cloud Foundry NATS server
  system_domain:
    description: Domain reserved for CF operator, base URL where the login, uaa, and
      other non-user apps listen
  uaa.jwt.verification_key:
    description: ssl cert defined in the manifest by the UAA, required by the cc to
      communicate with UAA

------------------------------------
Job: login
Removed:

---
packages:
- ruby_next

Added:

---
packages:
- ruby
properties:
  login.protocol:
    default: http
    description: The scheme in which login server should use to contact the UAA
  login.port:
    default: 8080

------------------------------------
Job: saml_login
Removed:

---
packages:
- ruby_next

Added:

---
packages:
- ruby

------------------------------------
Job: syslog_aggregator
Removed:

---
templates:
  nats_capture_run.erb: sv/nats_capture/run
  nats_capture_log: sv/nats_capture/log/run
  nats_capture_config: config/nats_capture_config
packages:
- ruby_next

Added:

---
templates:
  nats_stream_forwarder.rb: bin/nats_stream_forwarder.rb
  nats_stream_forwarder_ctl: bin/nats_stream_forwarder_ctl
packages:
- ruby

------------------------------------
Job: uaa
Removed:

---
packages:
- ruby_next

Added:

---
packages:
- ruby
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
