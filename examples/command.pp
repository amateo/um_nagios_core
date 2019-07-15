um_nagios_command {'check_nrpe_kk':
  ensure       => 'present',
  command_name => 'check_nrpe',
  command_line => '$USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -a $ARG2$',
  target       => '/tmp/commands.cfg',
}

