class tomcat::data {
  $oslower = downcase($::osfamily)
  $tomcat_template = "tomcat.${oslower}.erb"
}
