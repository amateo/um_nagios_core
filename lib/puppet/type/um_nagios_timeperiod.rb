Puppet::Type.newtype(:um_nagios_timeperiod) do
  desc <<-EOT
    Creates a nagios timeperiod object with augeas

    A timeperiod definition is used to define a physical server, workstation, device, etc. that resides on your network.
  EOT

  ensurable

  newparam(:name, :namevar => :true) do
    desc "The name of the puppet's nagios timeperiod resource"
  end

  newproperty(:timeperiod_name) do
    desc <<-EOT
    This directives is the short name used to identify the time period.
    EOT

    defaultto { @resource[:name] }
  end

  newproperty(:nagios_alias) do
    desc <<-EOT
    This directive is a longer name or description used to identify the time period.
    EOT
  end

  newproperty(:sunday, :array_matching => :all ) do
    desc <<-EOT
    The weekday directives ("sunday" through "saturday")are comma-delimited lists of time ranges that are "valid" times for a particular day of the week. Notice that there are seven different days for which you can define time ranges (Sunday through Saturday). Each time range is in the form of HH:MM-HH:MM, where hours are specified on a 24 hour clock. For example, 00:15-24:00 means 12:15am in the morning for this day until 12:00am midnight (a 23 hour, 45 minute total time range). If you wish to exclude an entire day from the timeperiod, simply do not include it in the timeperiod definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:monday, :array_matching => :all ) do
    desc <<-EOT
    The weekday directives ("sunday" through "saturday")are comma-delimited lists of time ranges that are "valid" times for a particular day of the week. Notice that there are seven different days for which you can define time ranges (Sunday through Saturday). Each time range is in the form of HH:MM-HH:MM, where hours are specified on a 24 hour clock. For example, 00:15-24:00 means 12:15am in the morning for this day until 12:00am midnight (a 23 hour, 45 minute total time range). If you wish to exclude an entire day from the timeperiod, simply do not include it in the timeperiod definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:tuesday, :array_matching => :all ) do
    desc <<-EOT
    The weekday directives ("sunday" through "saturday")are comma-delimited lists of time ranges that are "valid" times for a particular day of the week. Notice that there are seven different days for which you can define time ranges (Sunday through Saturday). Each time range is in the form of HH:MM-HH:MM, where hours are specified on a 24 hour clock. For example, 00:15-24:00 means 12:15am in the morning for this day until 12:00am midnight (a 23 hour, 45 minute total time range). If you wish to exclude an entire day from the timeperiod, simply do not include it in the timeperiod definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:wednesday, :array_matching => :all ) do
    desc <<-EOT
    The weekday directives ("sunday" through "saturday")are comma-delimited lists of time ranges that are "valid" times for a particular day of the week. Notice that there are seven different days for which you can define time ranges (Sunday through Saturday). Each time range is in the form of HH:MM-HH:MM, where hours are specified on a 24 hour clock. For example, 00:15-24:00 means 12:15am in the morning for this day until 12:00am midnight (a 23 hour, 45 minute total time range). If you wish to exclude an entire day from the timeperiod, simply do not include it in the timeperiod definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:thursday, :array_matching => :all ) do
    desc <<-EOT
    The weekday directives ("sunday" through "saturday")are comma-delimited lists of time ranges that are "valid" times for a particular day of the week. Notice that there are seven different days for which you can define time ranges (Sunday through Saturday). Each time range is in the form of HH:MM-HH:MM, where hours are specified on a 24 hour clock. For example, 00:15-24:00 means 12:15am in the morning for this day until 12:00am midnight (a 23 hour, 45 minute total time range). If you wish to exclude an entire day from the timeperiod, simply do not include it in the timeperiod definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:friday, :array_matching => :all ) do
    desc <<-EOT
    The weekday directives ("sunday" through "saturday")are comma-delimited lists of time ranges that are "valid" times for a particular day of the week. Notice that there are seven different days for which you can define time ranges (Sunday through Saturday). Each time range is in the form of HH:MM-HH:MM, where hours are specified on a 24 hour clock. For example, 00:15-24:00 means 12:15am in the morning for this day until 12:00am midnight (a 23 hour, 45 minute total time range). If you wish to exclude an entire day from the timeperiod, simply do not include it in the timeperiod definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:saturday, :array_matching => :all ) do
    desc <<-EOT
    The weekday directives ("sunday" through "saturday")are comma-delimited lists of time ranges that are "valid" times for a particular day of the week. Notice that there are seven different days for which you can define time ranges (Sunday through Saturday). Each time range is in the form of HH:MM-HH:MM, where hours are specified on a 24 hour clock. For example, 00:15-24:00 means 12:15am in the morning for this day until 12:00am midnight (a 23 hour, 45 minute total time range). If you wish to exclude an entire day from the timeperiod, simply do not include it in the timeperiod definition.
    EOT

    def insync?(is)
      is == should
    end
  end

  newproperty(:exclude, :array_matching => :all) do
    desc <<-EOT
       This directive is used to specify the short names of other timeperiod definitions whose time ranges should be excluded from this timeperiod. Multiple timeperiod names should be separated with a comma.
    EOT

    def insync?(is)
      is == should
    end
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
