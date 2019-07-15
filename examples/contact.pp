um_nagios_contact {'amateo':
  host_notification_period      => '24x7',
  service_notification_period   => '24x7',
  host_notification_options     => 'd,u,r,f',
  service_notification_options  => 'w,u,c,r,f',
  host_notification_commands    => 'host-notify-by-email',
  service_notification_commands => 'service-notify-by-email',
  can_submit_commands           => '1',
  contactgroups                 => [ 'Administrador_Telematica', 'cg2' ],
  tag                           => 'omd-nagios-telematica',
  contact_name                  => 'amateo@um.es',
  nagios_alias                  => 'Angel L. Mateo',
  email                         => 'amateo@um.es',
  target                        => '/tmp/contacts.cfg',
}

