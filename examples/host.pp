um_nagios_host {'joshua':
  host_name              => 'joshua',
  nagios_alias           => 'joshua.atica.um.es',
  address                => '192.168.1.1',
  display_name           => 'Mi ordenador',
  target                 => '/tmp/hosts.cfg',
  hostgroups             => [ 'hg1', 'hg2' ],
  #hostgroups            => [],
  contacts               => [ 'amateo', 'juanito' ],
  initial_state          => 'o',
  flap_detection_options => 'o,d',
  max_check_attempts     => 5,
}
