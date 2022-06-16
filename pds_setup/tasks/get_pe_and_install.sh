#! /usr/bin/env bash

set -e

# shellcheck disable=SC2154
platform_tag=$PT_platform_tag
# shellcheck disable=SC2154
pe_version=$PT_version
# shellcheck disable=SC2154
pe_family=$PT_family
# shellcheck disable=SC2154
workdir=${PT_workdir:-/root}

if [ -z "$pe_version" ] && [ -z "$pe_family" ]; then
  echo "Must set either version or family" >&2
  exit 1
fi

cd "$workdir"

if [ -n "$pe_version" ]; then
  pe_family=$(echo "$pe_version" | grep -oE '^[0-9]+\.[0-9]+')
fi

if [[ "$pe_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  release_version='true'
  base_url="https://artifactory.delivery.puppetlabs.net/artifactory/generic_enterprise__local/archives/releases/${pe_version}"
elif [[ "$pe_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+-rc[0-9]+$ ]]; then
  release_version='true'
  base_url="https://artifactory.delivery.puppetlabs.net/artifactory/generic_enterprise__local/archives/internal/${pe_family}"
else
  pe_major="${pe_family%.*}"

  # 2021 dev builds are actually all under 'main'
  if [ "$pe_major" -eq 2021 ]; then
    pe_branch='main'
  fi

  base_url="https://artifactory.delivery.puppetlabs.net/artifactory/generic_enterprise__local/${pe_branch:-$pe_family}/ci-ready"
fi

if [ -z "$pe_version" ]; then
  pe_version=$(curl "${base_url}/LATEST")
fi

pe_dir="puppet-enterprise-${pe_version}-${platform_tag}"

if [ "$release_version" == 'true' ]; then
  pe_tarball="${pe_dir}.tar.gz"
else
  pe_tarball="${pe_dir}.tar"
fi

pe_tarball_url="${base_url}/${pe_tarball}"

wget_code=0
tar_code=0

set +e
if [ ! -f "${pe_tarball}" ]; then
  wget -nv --quiet "${pe_tarball_url}"
  wget_code=$?
fi
if [ ! -d "${pe_dir}" ]; then
  tar -xf "${pe_tarball}"
  tar_code=$?
fi
set -e

if [ "$wget_code" != 0 ] || [ "$tar_code" != 0 ]; then
  echo "{
  \"_error\": {
    \"msg\": \"Failed either to wget or untar the PE tarball from ${pe_tarball_url}\",
    \"kind\": \"enterprise_tasks/get_pe\",
    \"details\": {
      \"wget_exit_code\": \"${wget_code}\",
      \"tar_exit_code\": \"${tar_code}\",
      \"pe_tarball_url\": \"${pe_tarball_url}\",
      \"pe_tarball\": \"${pe_tarball}\",
      \"pe_dir\": \"${pe_dir}\"
    }
  }
}"
  exit 1
fi

echo "{
  \"workdir\":\"${workdir}\",
  \"pe_dir\":\"${workdir}/${pe_dir}\",
  \"pe_tarball\":\"${pe_tarball}\",
  \"pe_tarball_url\":\"${pe_tarball_url}\",
  \"pe_family\":\"${pe_family}\",
  \"pe_version\":\"${pe_version}\"
}"

${workdir}/${pe_dir}/puppet-enterprise-installer -y -c ${workdir}/${pe_dir}/conf.d/pe.conf
echo "install complete"
puppet infra console_password --password puppetlabs
echo "admin password changed to 'puppetlabs'"
