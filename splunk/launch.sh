#!/bin/bash
# TO DO :
#  * Configuration. How? Nicely? Static ports, download paths
#  * how to test branches?? not just from the forge.
#
rm -f inventory.yaml

## PE Master
bundle exec rake 'litmus:provision[vmpooler,centos-7-x86_64-pixa3]'
pe_master=$(cat inventory.yaml | grep name: | awk '{ print $3 }' | grep -v nodes | head -1)
echo ">>> PE master is $pe_master"
bundle exec rake "litmus:install_pe[$pe_master]"
bundle exec bolt command run 'puppet module install puppetlabs-splunk_hec' -n $pe_master -i inventory.yaml


## Splunk server
bundle exec rake 'litmus:provision[vmpooler,centos-7-x86_64-pixa3]'
splunk_server=$(cat inventory.yaml | grep name: | awk '{ print $3 }' | grep -v nodes | grep -v $pe_master)
echo ">>> splunk server is $splunk_server"
bundle exec rake "litmus:install_agent[puppet6, $splunk_server]"
SPLUNK_DOWNLOAD="wget -O splunk.rpm 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.3.0&product=splunk&filename=splunk-7.3.0-657388c7a488-linux-2.6-x86_64.rpm&wget=true'"
bundle exec bolt command run "$SPLUNK_DOWNLOAD" -n $splunk_server -i inventory.yaml
bundle exec bolt command run "rpm -ivh splunk.rpm" -n $splunk_server -i inventory.yaml
# bundle exec bolt command run "puppet module install puppet-splunk" -n $splunk_server -i inventory.yaml
bundle exec bolt command run "yum install vim git -y" -n $splunk_server -i inventory.yaml
bundle exec bolt command run "echo -e \"[user_info]\n  USERNAME = admin\n  PASSWORD = simples1\n\" > /opt/splunk/etc/system/local/user-seed.conf"     -n $splunk_server -i inventory.yaml
START='/opt/splunk/bin/splunk start --accept-license --no-prompt'
bundle exec bolt command run "$START" -n $splunk_server -i inventory.yaml

#bundle exec bolt command run "puppet apply --debug ./splunk_server.pp" -n $splunk_server -i inventory.yaml

CREATE_TOKEN='/opt/splunk/bin/splunk http-event-collector create gregotoken "gregotoken" -index default -uri "https://localhost:8089" -auth admin:simples1'
# note : You will need to add the source type here.
splunk_token=$(bundle exec bolt command run "$CREATE_TOKEN" -n $splunk_server -i inventory.yaml | grep token= | cut -d\= -f2)

# add the splunk token to the splunk_hec module on the PE master
SPLUNK_HEC_CONFIG="---\n  \"url\" : \"https://$splunk_server:8088/services/collector\"\n  \"token\" : \"$splunk_token\""
bundle exec bolt command run "echo -e \"$SPLUNK_HEC_CONFIG\" > /etc/puppetlabs/puppet/splunk_hec.yaml" -n $pe_master -i inventory.yaml

ENABLE_HEC="/opt/splunk/bin/splunk http-event-collector enable gregotoken  -uri \"https://localhost:8089\" -auth admin:simples1"
ENABLE_DEFAULT_HEC="/opt/splunk/bin/splunk http-event-collector enable http  -uri \"https://localhost:8089\" -auth admin:simples1"
bundle exec bolt command run "$ENABLE_DEFAULT_HEC" -n $splunk_server -i inventory.yaml
bundle exec bolt command run "$ENABLE_HEC" -n $splunk_server -i inventory.yaml

## Install TA report viewer
bundle exec bolt command run "wget -O /tmp/1.3.5.tar.gz https://github.com/puppetlabs/TA-puppet-report-viewer/archive/1.3.5.tar.gz" -n $splunk_server -i inventory.yaml
bundle exec bolt command run "gunzip -c /tmp/1.3.5.tar.gz | tar -C /opt/splunk/etc/apps/ -xf -" -n $splunk_server -i inventory.yaml

RESTART='/opt/splunk/bin/splunk restart'
bundle exec bolt command run "$RESTART" -n $splunk_server -i inventory.yaml

## Do a notify on the puppet master to send data through the HEC
bundle exec bolt command run "puppet apply -e 'notify { \"hello world\": }' --reports=splunk_hec" -n $pe_master -i inventory.yaml
bundle exec bolt command run "puppet apply -e 'notify { \"hello world\": }' --reports=splunk_hec" -n $pe_master -i inventory.yaml
bundle exec bolt command run "puppet apply -e 'notify { \"hello world\": }' --reports=splunk_hec" -n $pe_master -i inventory.yaml

## Ensure that a splunk search will find the events
bundle exec bolt command run "/opt/splunk/bin/splunk search host=\"$pe_master\" -auth admin:simples1 | grep '\"status\":\"changed\"' | wc -l" -n $splunk_server -i inventory.yaml

#bundle exec rake 'litmus:tear_down'

