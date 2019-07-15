Puppet::Type.newtype(:um_nagios_contact) do
  desc <<-EOT
    Creates a nagios contact object with augeas

    A contact definition is used to identify someone who should be contacted in the event of a problem on your network.
  EOT

  ensurable

  newparam(:name, :namevar => :true) do
    desc "The name of the puppet's nagios contact resource"
  end

  newproperty(:contact_name) do
    desc <<-EOT
    This directive is used to define a short name used to identify the contact. It is referenced in contact group definitions. Under the right circumstances, the $CONTACTNAME$ macro will contain this value.
    EOT
    defaultto { @resource[:name] }
  end

  newproperty(:nagios_alias) do
    desc <<-EOT
    This directive is used to define a longer name or description for the contact. Under the rights circumstances, the $CONTACTALIAS$ macro will contain this value. If not specified, the contact_name will be used as the alias.
    This is the nagios 'alias' parameter.
    EOT
  end

  newproperty(:contactgroups, :array_matching => :all) do
    desc <<-EOT
    This directive is used to identify the short name(s) of the contactgroup(s) that the contact belongs to. Multiple contactgroups should be separated by commas. This directive may be used as an alternative to (or in addition to) using the members directive in contactgroup definitions.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:host_notifications_enabled) do
    desc <<-EOT
    This directive is used to determine whether or not the contact will receive notifications about host problems and recoveries. Values 0 = don't send notifications, 1 = send notifications.
    EOT

    newvalues(0, 1)
  end

  newproperty(:service_notifications_enabled) do
    desc <<-EOT
    This directive is used to determine whether or not the contact will receive notifications about service problems and recoveries. Values 0 = don't send notifications, 1 = send notifications.
    EOT

    newvalues(0, 1)
  end

  newproperty(:host_notification_period) do
    desc <<-EOT
    This directive is used to specify the short name of the time period during which the contact can be notified about host problems or recoveries. You can think of this as an "on call" time for host notifications for the contact. Read the documentation on time periods for more information on how this works and potential problems that may result from improper use.
    EOT
  end

  newproperty(:service_notification_period) do
    desc <<-EOT
    This directive is used to specify the short name of the time period during which the contact can be notified about service problems or recoveries. You can think of this as an "on call" time for service notifications for the contact. Read the documentation on time periods for more information on how this works and potential problems that may result from improper use.
    EOT
  end

  newproperty(:host_notification_commands) do
    desc <<-EOT
    This directive is used to define a list of the short names of the commands used to notify the contact of a host problem or recovery. Multiple notification commands should be separated by commas. All notification commands are executed when the contact needs to be notified. The maximum amount of time that a notification command can run is controlled by the notification_timeout option.
    EOT
  end

  newproperty(:host_notification_options) do
    desc <<-EOT
    This directive is used to define the host states for which notifications can be sent out to this contact. Valid options are a combination of one or more of the following d = notify on DOWN host states, u = notify on UNREACHABLE host states, r = notify on host recoveries (UP states), f = notify when the host starts and stops flapping, and s = send notifications when host or service scheduled downtime starts and ends. If you specify n (none) as an option, the contact will not receive any type of host notifications.
    EOT

    validate do |value|
      if !value.match?(/^([durfsn](,[durfsn])*)?$/) then
        raise ArgumentError, "host_notification_options must be a comma separated list of 'd', 'u', 'r', 'f', 's', 'n' (#{value} provided)"
      end
    end
  end

  newproperty(:service_notification_options) do
    desc <<-EOT
    This directive is used to define the service states for which notifications can be sent out to this contact. Valid options are a combination of one or more of the following w = notify on WARNING service states, u = notify on UNKNOWN service states, c = notify on CRITICAL service states, r = notify on service recoveries (OK states), and f = notify when the service starts and stops flapping. If you specify n (none) as an option, the contact will not receive any type of service notifications.
    EOT

    validate do |value|
      if !value.match?(/^([wucrfsn](,[wucrfsn])*)?$/) then
        raise ArgumentError, "flap_detection_options must be a comma separated list of 'w', 'u', 'c', 'r', 'f', 's', 'n' (#{value} provided)"
      end
    end
  end

  newproperty(:service_notification_commands) do
    desc <<-EOT
    This directive is used to define a list of the short names of the commands used to notify the contact of a service problem or recovery. Multiple notification commands should be separated by commas. All notification commands are executed when the contact needs to be notified. The maximum amount of time that a notification command can run is controlled by the notification_timeout option.
    EOT
  end

  newproperty(:email) do
    desc <<-EOT
    This directive is used to define an email address for the contact. Depending on how you configure your notification commands, it can be used to send out an alert email to the contact. Under the right circumstances, the $CONTACTEMAIL$ macro will contain this value.
    EOT
  end

  newproperty(:pager) do
    desc <<-EOT
    This directive is used to define a pager number for the contact. It can also be an email address to a pager gateway (i.e. pagejoe@pagenet.com). Depending on how you configure your notification commands, it can be used to send out an alert page to the contact. Under the right circumstances, the $CONTACTPAGER$ macro will contain this value.
    EOT
  end

  newproperty(:address1) do
    desc <<-EOT
    Address directives are used to define additional "addresses" for the contact. These addresses can be anything - cell phone numbers, instant messaging addresses, etc. Depending on how you configure your notification commands, they can be used to send out an alert to the contact. Up to six addresses can be defined using these directives (address1 through address6). The $CONTACTADDRESSx$ macro will contain this value.
    EOT
  end

  newproperty(:address2) do
    desc <<-EOT
    Address directives are used to define additional "addresses" for the contact. These addresses can be anything - cell phone numbers, instant messaging addresses, etc. Depending on how you configure your notification commands, they can be used to send out an alert to the contact. Up to six addresses can be defined using these directives (address1 through address6). The $CONTACTADDRESSx$ macro will contain this value.
    EOT
  end

  newproperty(:address3) do
    desc <<-EOT
    Address directives are used to define additional "addresses" for the contact. These addresses can be anything - cell phone numbers, instant messaging addresses, etc. Depending on how you configure your notification commands, they can be used to send out an alert to the contact. Up to six addresses can be defined using these directives (address1 through address6). The $CONTACTADDRESSx$ macro will contain this value.
    EOT
  end

  newproperty(:address4) do
    desc <<-EOT
    Address directives are used to define additional "addresses" for the contact. These addresses can be anything - cell phone numbers, instant messaging addresses, etc. Depending on how you configure your notification commands, they can be used to send out an alert to the contact. Up to six addresses can be defined using these directives (address1 through address6). The $CONTACTADDRESSx$ macro will contain this value.
    EOT
  end

  newproperty(:address5) do
    desc <<-EOT
    Address directives are used to define additional "addresses" for the contact. These addresses can be anything - cell phone numbers, instant messaging addresses, etc. Depending on how you configure your notification commands, they can be used to send out an alert to the contact. Up to six addresses can be defined using these directives (address1 through address6). The $CONTACTADDRESSx$ macro will contain this value.
    EOT
  end

  newproperty(:address6) do
    desc <<-EOT
    Address directives are used to define additional "addresses" for the contact. These addresses can be anything - cell phone numbers, instant messaging addresses, etc. Depending on how you configure your notification commands, they can be used to send out an alert to the contact. Up to six addresses can be defined using these directives (address1 through address6). The $CONTACTADDRESSx$ macro will contain this value.
    EOT
  end

  newproperty(:can_submit_commands) do
    desc <<-EOT
    This directive is used to determine whether or not the contact can submit external commands to Nagios from the CGIs. Values 0 = don't allow contact to submit commands, 1 = allow contact to submit commands.
    EOT

    newvalues(0, 1)
  end

  newproperty(:retain_status_information) do
    desc <<-EOT
    This directive is used to determine whether or not status-related information about the contact is retained across program restarts. This is only useful if you have enabled state retention using the retain_state_information directive. Value 0 = disable status information retention, 1 = enable status information retention.
    EOT

    newvalues(0, 1)
  end

  newproperty(:retain_nonstatus_information) do
    desc <<-EOT
    This directive is used to determine whether or not non-status information about the contact is retained across program restarts. This is only useful if you have enabled state retention using the retain_state_information directive. Value 0 = disable non-status information retention, 1 = enable non-status information retention.
    EOT

    newvalues(0, 1)
  end

  newproperty(:use) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:register) do
    desc 'Nagios configuration file parameter.'
    newvalues(0, 1)
  end

  newproperty(:custom) do
    validate do |value|
      if !value.is_a?(Hash)
        raise ArgumentError, "Custom key must be a hash of keys: values (#{v})"
      else
        value.each do |k, v|
          if !k.start_with?('_') then
            raise ArgumentError, "custom keys must begin with '_' (#{k})"
          end
        end
      end
    end
  end

  newparam(:target) do
    desc 'Nagios configuration file parameter.'
    validate do |value|
      unless value.start_with?('/')
        raise ArgumentError, 'target parameter must be an absolute path'
      end
    end
  end

end
