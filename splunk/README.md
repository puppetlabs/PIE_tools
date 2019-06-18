# Splunk/Puppet HEC/TA viewer framework launcher

## Intro

The splunk framework launcher constructs a Puppet splunk setup. The framework consists of a Puppet Enterprise Master with the puppetlabs-splunk_hec module installed and a Splunk Enterprise Server installed with the Puppet TA report viewer.

Puppet Enterprise Master
[https://github.com/puppetlabs/puppetlabs-splunk_hec](https://github.com/puppetlabs/puppetlabs-splunk_hec)

Splunk Enterprise Server
[https://github.com/puppetlabs/TA-puppet-report-viewer](https://github.com/puppetlabs/TA-puppet-report-viewer)

## Configure the launcher

No configuration is required at this time. You will need to have the vmpooler private key installed at :
$HOME/.ssh/id-rsa_acceptance

## To launch, install and configure the splunk setup

If you just require PE to be installed. Copy the following script to your
preferred Centos based node.

```bash
bundle install --path .bundle/gems
bundle exec rake launch
```

## Teardown of your resources

To clean up the framework simply execute this litmus command.

```bash
bundle exec rake 'litmus:tear_down'
```

