# Define: tomcat::war
#
#   Deploy tomcat war files.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   tomcat::war { 'hudson':
#     version => 'hudson-2.2.0',
#     filename => 'hudson-2.2.0.war'
#     source  => 'http://hudson-ci.org/downloads/war/2.2.0/hudson.war'
#   }
#
define tomcat::war (
  $version,
  $filename,
  $source,
  $config = undef,
  $owner  = hiera('tomcat_owner', 'tomcat'),
  $group  = hiera('tomcat_group', 'tomcat'),
  $target = hiera('tomcat_war_target', '/opt/tomcat')
) {

  include tomcat::data

  $war_path = "${target}/war"

  if ! defined(File[$war_path]) {
    file { $war_path:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => '0755',
    }
  }

  staging::file { $filename:
    source => $source,
  }

  staging::extract { $filename:
    # tar doesn't seem to extract a folder
    target  => "${war_path}/${version}",
    user    => $owner,
    group   => $group,
    creates => "$war_path/$version",
    require => Staging::File[$filename],
  }

  file { "${war_path}/${version}":
    ensure   => directory,
    recurse  => true,
    owner    => $owner,
    group    => $group,
    checksum => none,
    notify   => Class['tomcat::service'],
  }

  file { "${target}/webapps/${name}":
    ensure  => symlink,
    target  => "${war_path}/${version}",
    require => [ File["${war_path}/${version}"], Staging::Extract[$filename] ],
    notify  => Class['tomcat::service'],
  }

}
