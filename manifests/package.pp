# Class: tomcat::package
#
#   Installs tomcat software either via binary or packages.
#
# Parameters:
#   * uid: tomcat user id.
#   * gid: tomcat user gid.
#   * shell: tomcat user shell.
#   * deployment: tomcat deployment method, either file or package.
#   * package_name: tomcat software package name.
#   * version: tomcat software version (for package deploymetn also support installed, latest).
#   * source: tomcat software source for file install. (supports puppet:// as well as http://)
#   * target: tomcat software installation directory
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class tomcat::package (
  $uid          = hiera('tomcat_uid', 201),
  $gid          = hiera('tomcat_gid', 201),
  $shell        = hiera('tomcat_shell', '/bin/nologin'),
  $deployment   = hiera('tomcat_deployment', 'file'),
  $package_name = hiera('tomcat_package_name', 'tomcat'),
  $version      = hiera('tomcat_version', 'apache-tomact-6.0.35'),
  # settings below only relevant for file deployment
  $filename     = hiera('tomcat_filename', 'apache-tomcat-6.0.35.tar.gz'),
  $source       = hiera('tomcat_source', 'http://apache.mirrorcatalogs.com/tomcat/tomcat-6/v6.0.35/bin/apache-tomcat-6.0.35.tar.gz'),
  $target       = hiera('tomcat_target', '/opt')
) {

  include staging

  group { 'tomcat':
    ensure => present,
    gid    => $uid,
  }

  user { 'tomcat':
    ensure => present,
    uid    => $uid,
    gid    => $gid,
    shell  => $shell,
  }

  case $deployment {
    'file': {
      $tomcat_dir = "${target}/${version}"

      staging::file { $filename:
        source => $source,
      }

      staging::extract { $filename:
        target => $target,
        creates => $tomcat_dir,
        require => Staging::File[$filename],
      }


      file { $tomcat_dir:
        ensure   => directory,
        recurse  => true,
        owner    => 'tomcat',
        group    => 'tomcat',
        checksum => 'none',
        require  => Staging::Extract[$version],
      }

      file { "${target}/tomcat":
        ensure => symlink,
        target => $tomcat_dir,
        require => File[$tomcat_dir],
      }
    }

    'package': {
      package { $package_name:
        ensure => $version,
      }
    }

    default: {
      fail("tomcat::package: unknown deployment method ${deployment}")
    }
  }

}
