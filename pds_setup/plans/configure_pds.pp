#This plan will pull down a PE tarball from artifactory, install it on a node, and set up Puppet Data service to be served from the primary server acting as both the pds database and pds server.
#For now, the database and server params are set to the primary fqdn only; this is not tested on standalone postgres nodes
#TODO - make the setup configurable to use nodes other than primary
#TODO - support the use of compilers as pds database hosts
# @param fdqn The fqdn of the to-be puppet data service.
# @param control_repo_url The url to the control repository (remote or local, default git@github.com:puppetlabs/pds-integration-control-repo)
# @param control_repo_private_key_path If the repo requires a key to reach,
#   this is the absolute path to the location of the key on the primary (default /root/id-control_repo)
# @param install_pe install a fresh PE on given node (default true)
# @param platform platform type for PE tarball (default el-7-x86_64)
# @param version The PE version for the install (default 2021.5.0).
plan pds_setup::configure_pds(
  TargetSpec $fqdn,
  String $control_repo_url	= "git@github.com:puppetlabs/pds-integration-control-repo",
  String $control_repo_private_key_path	= "/root/id-control_repo",
  Boolean $install_pe = true,
  String $platform	= "el-7-x86_64",
  String $version	= "2021.5.0"
) {

  if install_pe {
    run_task(pds_setup::get_pe_and_install, $fqdn, version => $version, platform_tag => $platform)
    #Run puppet twice as recommended by installer
    out::message('Puppet Run 1')
    run_task(pds_setup::run_puppet, $fqdn)
    out::message('Puppet Run 2')
    run_task(pds_setup::run_puppet, $fqdn)
  }

  upload_file($control_repo_private_key_path, '/root/id-control_repo', $fqdn)
  run_task(pds_setup::setup_code_manager, $fqdn, r10k_remote => $control_repo_url, r10k_private_key => '/root/id-control_repo' )
  run_task('pds_setup::update_node_group', $fqdn,
    'group_name'       => 'PE Master',
    'class_parameters' => {
      'puppet_enterprise::profile::master' => {
        'code_manager_auto_configure' => true,
        'r10k_remote'                 => $control_repo_url,
        'r10k_private_key'            => '/etc/puppetlabs/puppetserver/ssh/id-control_repo',
      }
    },
  )

  out::message('Puppet Run post codemanager changes')
  run_task(pds_setup::run_puppet, $fqdn)
  run_command('puppet code deploy production --wait', $fqdn)
  out::message('Puppet Run post code repo deploy')
  run_task(pds_setup::run_puppet, $fqdn)

  run_task('pds_setup::update_node_group', $fqdn,
    'group_name'       => 'PE Master',
    'class_parameters' => {
      'puppet_data_service::database' => {
      }
    },
  )
  run_task(pds_setup::run_puppet, $fqdn)
  $uuid = run_command("uuidgen", $fqdn).first['stdout'].strip
  out::message("PDS Admin user UUID: ${uuid}")
  run_task('pds_setup::update_node_group', $fqdn,
    'group_name'        => 'PE Master',
    'class_parameters'  => {
      'puppet_data_service::server' => {
        'database_host' => $fqdn,
      }
    },
    'config_data'       => {
      "puppet_data_service::server" => {
        "pds_token" => $uuid
      }
    }
  )
  run_task(pds_setup::run_puppet, $fqdn)


}
