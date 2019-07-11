Puppet::Type.newtype(:um_nagios_contact) do
  desc <<-EOT
    Creates a nagios contact object with augeas

  EOT

  ensurable

  newparam(:name, :namevar => :true) do
    desc "The name of the puppet's nagios contact resource"
  end

  newproperty(:contact_name) do
    desc 'The name of this nagios_contact resource.'
    defaultto { @resource[:name] }
  end

  newproperty(:address1) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:address2) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:address3) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:address4) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:address5) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:address6) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:nagios_alias) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:can_submit_commands) do
    desc 'Nagios configuration file parameter.'
    newvalues(0, 1)
  end

  #newproperty(:contactgroups) do
  #end
  newproperty(:contactgroups, :array_matching => :all) do
    #def sync
    #  debug("CONTACTGROUPS SYNC")
    #  debug("CONTACTGROUPS SYNC SHOULD: #{self.should}")
    #  #debug("CONTACTGROUPS SYNC PROVIDER: #{provider.value}")
    #  self.should = self.should.join(',')
    #end
    def insync?(is)
      debug("CG INSYNC: '#{is}' '#{should}'")
      is == should
    end
  end
  ##newproperty(:contactgroups, :array_matching => :all) do
  ##  desc 'Nagios configuration file parameter.'
  ##
  ##  def insync?(is)
  ##    if should.length == 1
  ##      should[0].split(/,\s*/) == is.split(/,\s*/)
  ##    else
  ##      should == is.split(/,\s*/)
  ##    end
  ##  end
  ##end

  newproperty(:email) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:host_notification_commands) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:host_notification_options) do
    desc 'Nagios configuration file parameter.'
    newvalues('d', 'u', 'r', 'f', 's', 'n')
  end

  newproperty(:host_notification_period) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:host_notifications_enabled) do
    desc 'Nagios configuration file parameter.'
    newvalues(0, 1)
  end

  newproperty(:pager) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:register) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:retain_nonstatus_information) do
    desc 'Nagios configuration file parameter.'
    newvalues(0, 1)
  end

  newproperty(:retain_status_information) do
    desc 'Nagios configuration file parameter.'
    newvalues(0, 1)
  end

  newproperty(:service_notification_commands) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:service_notification_options) do
    desc 'Nagios configuration file parameter.'
    validate do |value|
      if !value.match?(/^([wucrfsn](,[wucrfsn])*)?$/) then
        raise ArgumentError, "service_notification_options must be a comma separated list of 'w', 'u', 'c', 'r', 'f', 's', 'n' (#{value} provided)"
      end
    end

    def insync?(is)
      if is == nil then
        should == ''
      else
        is == should
      end
    end
  end

  newproperty(:service_notification_period) do
    desc 'Nagios configuration file parameter.'
  end

  newproperty(:service_notifications_enabled) do
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

  newproperty(:use) do
    desc 'Nagios configuration file parameter.'
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
