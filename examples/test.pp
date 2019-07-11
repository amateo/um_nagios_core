
#um_nagios_contact {'luis':
#  contact_name => 'luis',
#}
#
#
#um_nagios_contact {'juanito':
#  email => 'juanito@um.es',
#}
#
#um_nagios_contact {'pepito':
#  email => 'pepitokk@um.es',
#}

um_nagios_contact {'fulanito':
  #ensure                       => 'absent',
  target                        => '/tmp/contacts.cfg',
  contact_name                  => 'fulanito',
  email                         => 'fulanito@um.es',
  can_submit_commands           => 1,
  retain_nonstatus_information  => 1,
  #service_notification_options => 'w,c',
  service_notification_options  => '',
  #host_notification_commands   => undef,
  host_notification_commands    => 'command1',
}
