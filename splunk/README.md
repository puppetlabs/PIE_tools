# Splunk/Puppet HEC/TA viewer framework launcher

## Intro

The splunk framework launcher constructs a Puppet splunk setup. The framework consists of a Puppet Enterprise Master with the puppetlabs-splunk_hec module installed and a Splunk Enterprise Server installed with the Puppet TA report viewer.

Puppet Enterprise Master
[https://github.com/puppetlabs/puppetlabs-splunk_hec](https://github.com/puppetlabs/puppetlabs-splunk_hec)

Splunk Enterprise Server
[https://github.com/puppetlabs/TA-puppet-report-viewer](https://github.com/puppetlabs/TA-puppet-report-viewer)

# Launching in Amazon AWS

## Configure the launcher

You will need to export your AWS credentials, region and private key file:

export AWS_ACCESS_KEY_ID = 'xxxxxxx'
export AWS_SECRET_ACCESS_KEY = 'yyyyyyy'
export AWS_REGION = 'eu-west-1'
export AWS_PRIVATE_KEY=~/.ssh/gregohardy.pem

You will need to have the AWS private key installed at :
$HOME/.ssh/ .e.g gregohardy.pem. (This is created in the Amazon Console UI)

The system wont start until you have exported these credentials.

## AWS Setup

```bash
bundle install --path .bundle/gems
```

## To provision the system in AWS

The setup is launced in vmpooler. It will create a Puppet Master and Splunk Enterprise node.
An agent will already be installed on the Splunk Server.

```bash
bundle exec rake provision_aws
```

## To configure the splunk server

To configure the splunk setup simply run

```bash
bundle exec rake configure_aws
```

## Inecting data into Splunk (via puppetlabs-splunk-hec)

The inject task will execute a bolt plan. The plan will run a puppet apply on the Puppet Enterprise 
node and direct the splunk-hec module to create a splunk-hec report. This will be sent to the Splunk
HTTP Endpoint Collector.

```bash
bundle exec rake inject_aws
```

## Its all about the data. How do I view my data in splunk?

There are two ways. You can log into the Splunk Enterprise server.

To find out your Splunk server FQDN 

```bash
$ bundle exec rake splunk_server
Splunk Master <an FQDN>

http://<the previous FQDN>:8000

Login  : admin
Passwd : simples1

Select in the top left -> TA Report viewer and marvel at your data empire.
```

or

To view your data by host.

```bash
bundle exec rake verify
```

## Teardown

To clean up your resources.

```bash
bundle exec rake clean
```

## Help commands

```bash
$ bundle exec rake puppet_master
Puppet Master ip-10-200-10-181.eu-west-1.compute.internal

$ bundle exec rake splunk_server
Splunk Master ip-10-200-10-182.eu-west-1.compute.internal
```

# Launching in Puppet VM pooler 

## Configure the launcher 

No configuration is required at this time. You will need to have the vmpooler private key installed at :
$HOME/.ssh/id-rsa_acceptance

## Setup

```bash
bundle install --path .bundle/gems
```

## To provision the system

The setup is launced in vmpooler. It will create a Puppet Master and Splunk Enterprise node.
An agent will already be installed on the Splunk Server.

```bash
bundle exec rake provision
```

## To configure the splunk server

To configure the splunk setup simply run

```bash
bundle exec rake configure
```

## Inecting data into Splunk (via puppetlabs-splunk-hec)

The inject task will execute a bolt plan. The plan will run a puppet apply on the Puppet Enterprise 
node and direct the splunk-hec module to create a splunk-hec report. This will be sent to the Splunk
HTTP Endpoint Collector.

```bash
bundle exec rake inject
```

## Its all about the data. How do I view my data in splunk?

There are two ways. You can log into the Splunk Enterprise server.

To find out your Splunk server FQDN 

```bash
$ bundle exec rake splunk_server
Splunk Master <an FQDN>

http://<the previous FQDN>:8000

Login  : admin
Passwd : simples1

Select in the top left -> TA Report viewer and marvel at your data empire.
```

or

To view your data by host.

```bash
bundle exec rake verify
```

## Teardown

To clean up your resources.

```bash
bundle exec rake clean
```

## Help commands

```bash
$ bundle exec rake puppet_master
Puppet Master d6v5mmjjwq6en12.delivery.puppetlabs.net

$ bundle exec rake splunk_server
Splunk Master dwgn8mcp0zxdpny.delivery.puppetlabs.net
```



