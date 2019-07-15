um_nagios_timeperiod {'horario_laboral':
  nagios_alias => 'Lunes a viernes en horario laboral',
  monday       => [ '07:30-15:30', '16:00-23:59', ],
  tuesday      => '07:30-15:30',
  wednesday    => '07:30-15:30',
  thursday     => '07:30-15:30',
  friday       => '07:30-15:30',
  target       => '/tmp/timeperiods.cfg',
}

