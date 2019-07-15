Puppet::Type.newtype(:um_nagios_service) do
  desc <<-EOT
    Creates a nagios service object with augeas

    A service definition is used to identify a "service" that runs on a host. The term "service" is used very loosely. It can mean an actual service that runs on the host (POP, SMTP, HTTP, etc.) or some other type of metric associated with the host (response to a ping, number of logged in users, free disk space, etc.).
  EOT

  ensurable

  newparam(:name, :namevar => :true) do
    desc "The name of the puppet's nagios service resource"
  end

  newproperty(:host_name) do
    desc <<-EOT
    This directive is used to specify the short name(s) of the host(s) that the service "runs" on or is associated with. Multiple hosts should be separated by commas.
    EOT
  end

  newproperty(:hostgroup_name, :array_matching => :all) do
    desc <<-EOT
    This directive is used to specify the short name(s) of the hostgroup(s) that the service "runs" on or is associated with. Multiple hostgroups should be separated by commas. The hostgroup_name may be used instead of, or in addition to, the host_name directive.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:service_description) do
    desc <<-EOT
    This directive is used to define the description of the service, which may contain spaces, dashes, and colons (semicolons, apostrophes, and quotation marks should be avoided). No two services associated with the same host can have the same description. Services are uniquely identified with their host_name and service_description directives.
    EOT
  end

  newproperty(:display_name) do
    desc <<-EOT
    This directive is used to define an alternate name that should be displayed in the web interface for this service. If not specified, this defaults to the value you specify for the service_description directive. Note) do
    EOT
  end

  newproperty(:servicegroups, :array_matching => :all) do
    desc <<-EOT
    This directive is used to identify the short name(s) of the servicegroup(s) that the service belongs to. Multiple servicegroups should be separated by commas. This directive may be used as an alternative to using the members directive in servicegroup definitions.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:is_volatile) do
    desc <<-EOT
    This directive is used to denote whether the service is "volatile". Services are normally not volatile. More information on volatile service and how they differ from normal services can be found here.
    EOT
    newvalues(0, 1)
  end

  newproperty(:check_command) do
    desc <<-EOT
    This directive is used to specify the short name of the command that Nagios will run in order to check the status of the service. The maximum amount of time that the service check command can run is controlled by the service_check_timeout option.
    EOT
  end

  newproperty(:initial_state) do
    desc <<-EOT
    By default Nagios will assume that all services are in OK states when it starts. You can override the initial state for a service by using this directive. Valid options are o = OK, w = WARNING, u = UNKNOWN, and c = CRITICAL.
    EOT

    newvalues('o', 'w', 'u', 'c')
  end

  newproperty(:max_check_attempts) do
    desc <<-EOT
    This directive is used to define the number of times that Nagios will retry the service check command if it returns any state other than an OK state. Setting this value to 1 will cause Nagios to generate an alert without retrying the service check again.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "max_check_attempts must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:check_interval) do
    desc <<-EOT
    This directive is used to define the number of "time units" to wait before scheduling the next "regular" check of the service. "Regular" checks are those that occur when the service is in an OK state or when the service is in a non-OK state, but has already been rechecked max_check_attempts number of times. Unless you've changed the interval_length directive from the default value of 60, this number will mean minutes. More information on this value can be found in the check scheduling documentation.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "check_interval must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:retry_interval) do
    desc <<-EOT
    This directive is used to define the number of "time units" to wait before scheduling a re-check of the service. Services are rescheduled at the retry interval when they have changed to a non-OK state. Once the service has been retried max_check_attempts times without a change in its status, it will revert to being scheduled at its "normal" rate as defined by the check_interval value. Unless you've changed the interval_length directive from the default value of 60, this number will mean minutes. More information on this value can be found in the check scheduling documentation.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "retry_interval must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:active_checks_enabled) do
    desc <<-EOT
    This directive is used to determine whether or not active checks of this service are enabled. Values 0 = disable active service checks, 1 = enable active service checks (default).
    EOT

    newvalues(0, 1)
  end

  newproperty(:passive_checks_enabled) do
    desc <<-EOT
    This directive is used to determine whether or not passive checks of this service are enabled. Values 0 = disable passive service checks, 1 = enable passive service checks (default).
    EOT

    newvalues(0, 1)
  end

  newproperty(:check_period) do
    desc <<-EOT
    This directive is used to specify the short name of the time period during which active checks of this service can be made.
    EOT
  end

  newproperty(:obsess_over_service) do
    desc <<-EOT
    This directive determines whether or not checks for the service will be "obsessed" over using the ocsp_command.
    EOT

    newvalues(0, 1)
  end

  newproperty(:check_freshness) do
    desc <<-EOT
    This directive is used to determine whether or not freshness checks are enabled for this service. Values 0 = disable freshness checks, 1 = enable freshness checks (default).
    EOT

    newvalues(0, 1)
  end

  newproperty(:freshness_threshold) do
    desc <<-EOT
    This directive is used to specify the freshness threshold (in seconds) for this service. If you set this directive to a value of 0, Nagios will determine a freshness threshold to use automatically.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "freshness_threshold must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:event_handler) do
    desc <<-EOT
    This directive is used to specify the short name of the command that should be run whenever a change in the state of the service is detected (i.e. whenever it goes down or recovers). Read the documentation on event handlers for a more detailed explanation of how to write scripts for handling events. The maximum amount of time that the event handler command can run is controlled by the event_handler_timeout option.
    EOT
  end

  newproperty(:event_handler_enabled) do
    desc <<-EOT
    This directive is used to determine whether or not the event handler for this service is enabled. Values 0 = disable service event handler, 1 = enable service event handler.
    EOT

    newvalues(0, 1)
  end

  newproperty(:low_flap_threshold) do
    desc <<-EOT
    This directive is used to specify the low state change threshold used in flap detection for this service. More information on flap detection can be found here. If you set this directive to a value of 0, the program-wide value specified by the low_service_flap_threshold directive will be used.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "low_flap_threshold must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:high_flap_threshold) do
    desc <<-EOT
    This directive is used to specify the high state change threshold used in flap detection for this service. More information on flap detection can be found here. If you set this directive to a value of 0, the program-wide value specified by the high_service_flap_threshold directive will be used.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "high_flap_threshold must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:flap_detection_enabled) do
    desc <<-EOT
    This directive is used to determine whether or not flap detection is enabled for this service. More information on flap detection can be found here. Values 0 = disable service flap detection, 1 = enable service flap detection.
    EOT

    newvalues(0, 1)
  end

  newproperty(:flap_detection_options) do
    desc <<-EOT
    This directive is used to determine what service states the flap detection logic will use for this service. Valid options are a combination of one or more of the following o = OK states, w = WARNING states, c = CRITICAL states, u = UNKNOWN states.
    EOT

    validate do |value|
      if !value.match?(/^([owcu](,[owcu])*)?$/) then
        raise ArgumentError, "flap_detection_options must be a comma separated list of 'o', 'w', 'c', 'u' (#{value} provided)"
      end
    end
  end

  newproperty(:process_perf_data) do
    desc <<-EOT
    This directive is used to determine whether or not the processing of performance data is enabled for this service. Values 0 = disable performance data processing, 1 = enable performance data processing.
    EOT

    newvalues(0, 1)
  end

  newproperty(:retain_status_information) do
    desc <<-EOT
    This directive is used to determine whether or not status-related information about the service is retained across program restarts. This is only useful if you have enabled state retention using the retain_state_information directive. Value 0 = disable status information retention, 1 = enable status information retention.
    EOT

    newvalues(0, 1)
  end

  newproperty(:retain_nonstatus_information) do
    desc <<-EOT
    This directive is used to determine whether or not non-status information about the service is retained across program restarts. This is only useful if you have enabled state retention using the retain_state_information directive. Value 0 = disable non-status information retention, 1 = enable non-status information retention.
    EOT

    newvalues(0, 1)
  end

  newproperty(:notification_interval) do
    desc <<-EOT
    This directive is used to define the number of "time units" to wait before re-notifying a contact that this service is still in a non-OK state. Unless you've changed the interval_length directive from the default value of 60, this number will mean minutes. If you set this value to 0, Nagios will not re-notify contacts about problems for this service - only one problem notification will be sent out.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "notification_interval must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:first_notification_delay) do
    desc <<-EOT
    This directive is used to define the number of "time units" to wait before sending out the first problem notification when this service enters a non-OK state. Unless you've changed the interval_length directive from the default value of 60, this number will mean minutes. If you set this value to 0, Nagios will start sending out notifications immediately.
    EOT

    validate do |value|
      if (value.is_a?(String) and !value.match(/^[0-9]+$/)) or (!value.is_a?(String) and !value.is_a?(Integer)) then
        raise ArgumentError, "first_notification_delay must be an integer (#{value} provided)"
      end
    end
  end

  newproperty(:notification_period) do
    desc <<-EOT
    This directive is used to specify the short name of the time period during which notifications of events for this service can be sent out to contacts. No service notifications will be sent out during times which is not covered by the time period.
    EOT
  end

  newproperty(:notification_options) do
    desc <<-EOT
    This directive is used to determine when notifications for the service should be sent out. Valid options are a combination of one or more of the following: w = send notifications on a WARNING state, u = send notifications on an UNKNOWN state, c = send notifications on a CRITICAL state, r = send notifications on recoveries (OK state), f = send notifications when the service starts and stops flapping, and s = send notifications when scheduled downtime starts and ends. If you specify n (none) as an option, no service notifications will be sent out. If you do not specify any notification options, Nagios will assume that you want notifications to be sent out for all possible states. Example If you specify w,r in this field, notifications will only be sent out when the service goes into a WARNING state and when it recovers from a WARNING state.
    EOT

    validate do |value|
      if !value.match?(/^([wucrfs](,[wucrfs])*)?$/) then
        raise ArgumentError, "notification_options must be a comma separated list of 'w', 'u', 'c', 'r', 'f', 's' (#{value} provided)"
      end
    end
  end

  newproperty(:notifications_enabled) do
    desc <<-EOT
    This directive is used to determine whether or not notifications for this service are enabled. Values 0 = disable service notifications, 1 = enable service notifications.
    EOT

    newvalues(0, 1)
  end

  newproperty(:contacts, :array_matching => :all) do
    desc <<-EOT
    This is a list of the short names of the contacts that should be notified whenever there are problems (or recoveries) with this service. Multiple contacts should be separated by commas. Useful if you want notifications to go to just a few people and don't want to configure contact groups. You must specify at least one contact or contact group in each service definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:contact_groups, :array_matching => :all) do
    desc <<-EOT
    This is a list of the short names of the contact groups that should be notified whenever there are problems (or recoveries) with this service. Multiple contact groups should be separated by commas. You must specify at least one contact or contact group in each service definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:stalking_options) do
    desc <<-EOT
    This directive determines which service states "stalking" is enabled for. Valid options are a combination of one or more of the following o = stalk on OK states, w = stalk on WARNING states, u = stalk on UNKNOWN states, and c = stalk on CRITICAL states. More information on state stalking can be found here.
    EOT

    validate do |value|
      if !value.match?(/^([owuc](,[owuc])*)?$/) then
        raise ArgumentError, "stalking_options must be a comma separated list of 'o', 'w', 'u', 'c' (#{value} provided)"
      end
    end
  end

  newproperty(:notes) do
    desc <<-EOT
    This directive is used to define an optional string of notes pertaining to the service. If you specify a note here, you will see the it in the extended information CGI (when you are viewing information about the specified service).
    EOT
  end

  newproperty(:notes_url) do
    desc <<-EOT
    This directive is used to define an optional URL that can be used to provide more information about the service. If you specify an URL, you will see a red folder icon in the CGIs (when you are viewing service information) that links to the URL you specify here. Any valid URL can be used. If you plan on using relative paths, the base path will the the same as what is used to access the CGIs (i.e. /cgi-bin/nagios/). This can be very useful if you want to make detailed information on the service, emergency contact methods, etc. available to other support staff.
    EOT
  end

  newproperty(:action_url) do
    desc <<-EOT
    This directive is used to define an optional URL that can be used to provide more actions to be performed on the service. If you specify an URL, you will see a red "splat" icon in the CGIs (when you are viewing service information) that links to the URL you specify here. Any valid URL can be used. If you plan on using relative paths, the base path will the the same as what is used to access the CGIs (i.e. /cgi-bin/nagios/).
    EOT
  end

  newproperty(:icon_image) do
    desc <<-EOT
    This variable is used to define the name of a GIF, PNG, or JPG image that should be associated with this service. This image will be displayed in the status and extended information CGIs. The image will look best if it is 40x40 pixels in size. Images for services are assumed to be in the logos/ subdirectory in your HTML images directory (i.e. /usr/local/nagios/share/images/logos).
    EOT
  end

  newproperty(:icon_image_alt) do
    desc <<-EOT
    This variable is used to define an optional string that is used in the ALT tag of the image specified by the <icon_image> argument. The ALT tag is used in the status, extended information and statusmap CGIs. 
    EOT
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
