class tomcat::data {
  $oslower = downcase($::osfamily)
  $tomcat_template = "${module_name}/tomcat.${oslower}.erb"
}
