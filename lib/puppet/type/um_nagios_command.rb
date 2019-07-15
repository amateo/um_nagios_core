Puppet::Type.newtype(:um_nagios_command) do
  desc <<-EOT
    Creates a nagios command object with augeas

    A command definition is just that. It defines a command. Commands that can be defined include service checks, service notifications, service event handlers, host checks, host notifications, and host event handlers. Command definitions can contain macros, but you must make sure that you include only those macros that are "valid" for the circumstances when the command will be used. More information on what macros are available and when they are "valid" can be found here.
  EOT

  ensurable

  newparam(:name, :namevar => :true) do
    desc "The name of the puppet's nagios command resource"
  end

  newproperty(:command_name) do
    desc <<-EOT
    This directive is the short name used to identify the command. It is referenced in contact, host, and service definitions (in notification, check, and event handler directives), among other places.
    EOT

    defaultto { @resource[:name] }
  end

  newproperty(:command_line) do
    desc <<-EOT
      This directive is used to define what is actually executed by Nagios when the command is used for service or host checks, notifications, or event handlers. Before the command line is executed, all valid macros are replaced with their respective values. See the documentation on macros for determining when you can use different macros. Note that the command line is not surrounded in quotes. Also, if you want to pass a dollar sign ($) on the command line, you have to escape it with another dollar sign.

      NOTE: You may not include a semicolon (;) in the command_line directive, because everything after it will be ignored as a config file comment. You can work around this limitation by setting one of the $USER$ macros in your resource file to a semicolon and then referencing the appropriate $USER$ macro in the command_line directive in place of the semicolon.

      If you want to pass arguments to commands during runtime, you can use $ARGn$ macros in the command_line directive of the command definition and then separate individual arguments from the command name (and from each other) using bang (!) characters in the object definition directive (host check command, service event handler command, etc) that references the command. More information on how arguments in command definitions are processed during runtime can be found in the documentation on macros.
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
