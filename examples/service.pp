um_nagios_service {'Servicio_Generico_Telematica':
  max_check_attempts     => '3',
  check_interval         => '5',
  retry_interval         => '1',
  check_period           => '24x7',
  active_checks_enabled  => '1',
  obsess_over_service    => '0',
  check_freshness        => '0',
  flap_detection_enabled => '1',
  notification_interval  => '120',
  notification_period    => '24x7',
  notification_options   => 'w,u,c,r',
  notifications_enabled  => '1',
  contact_groups         => 'Administrador_Telematica',
  register               => '0',
  tag                    => 'omd-nagios-telematica',
  target                 => '/tmp/services.cfg',
}

um_nagios_service {'Replica LDAP Publico':
  host_name           => 'tlm_ldapinfo.um.es',
  service_description => 'Replica LDAP Publico',
  use                 => 'Servicio_Generico_Telematica',
  check_command       => 'check_ldap_replica!389!cn=nagios,ou=People,ou=Management,o=SlapdRoot!%{hiera("profile::slapd::nagios::server::pw")}!dc=um,dc=es!600!900!lepus11.um.es#011,lepus12.um.es#012,lepus19.um.es#019',
  tag                 => 'omd-nagios-telematica',
  target              => '/tmp/services.cfg',
}
