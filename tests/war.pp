tomcat::war { 'jenkins':
  version  => 'hudson-2.2.0',
  filename => 'hudson-2.2.0.war',
  source   => 'http://hudson-ci.org/downloads/war/2.2.0/hudson.war',
}
