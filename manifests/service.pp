# Class: tomcat::service
#
#   tomcat service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class tomcat::service (
  $service_name = hiera('tomcat_service_name', 'tomcat'),
  $template     = hiera('tomcat_template'),
  $target       = hiera('tomcat_target', '/opt')
){

  $tomcat_home = "${target}/tomcat"

  file { '/etc/init.d/tomcat':
    owner => 'root',
    group => 'root',
    mode  => '0755',
    content  => template($template),
  }

  service { $service_name:
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => File['/etc/init.d/tomcat'],
    #subscribe  => Class['tomcat::config'],
  }
}
