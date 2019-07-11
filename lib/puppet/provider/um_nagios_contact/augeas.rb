# coding: utf-8
# Alternative Augeas-based providers for Puppet
#
# Copyright (c) 2019 Ángel L. Mateo (amateo@um.es)
# Licensed under the Apache License, Version 2.0


raise("Missing augeasproviders_core dependency") if Puppet::Type.type(:augeasprovider).nil?
Puppet::Type.type(:um_nagios_contact).provide(:augeas, :parent => Puppet::Type.type(:augeasprovider).provider(:default)) do
  desc "Uses Augeas API to update an ssh_config parameter"

  #default_file { '/etc/nagios/conf.d/contacts.cfg' }
  default_file { '/home/amateo/git/puppet/um_nagios_core/examples/conf.d/contacts.cfg' }

  lens { 'Nagiosobjects.lns' }

  confine :feature => :augeas

  resource_path do |resource|
    if resource[:target]
      "/files/#{resource[:target]}/contact[name = '#{resource[:name]}']"
    else
      "$target/contact[name = '#{resource[:name]}']"
    end
  end

  def self.instances
    resources = []
    augopen do |aug|
      settings = aug.match("$target/contact")

      settings.each do |node|
        aug.defvar('resource', node)

        email = attr_aug_reader_email(aug)
        contact_name = attr_aug_reader_contact_name(aug)
        can_submit_commands = attr_aug_reader_can_sumbit_commands(aug)
        name = contact_name if !name

        entry = {
          :ensure => :present,
          :name => name,
          :contact_name => contact_name,
          :email => email,
          :can_submit_commands => can_submit_commands,
        }
        resources << new(entry)
      end
    end
    resources
  end

  def create
    path = resource_path
    #contact_name = resource[:contact_name]
    #email = resource[:email]
    augopen! do |aug|

      aug.set("#{path}/name", resource[:name])
      setvars(aug)
      attr_aug_writer_contact_name(aug, contact_name) if contact_name
      #attr_aug_writer_email(aug, email) if email
      #attr_aug_writer_can_submit_commands(aug, can_submit_commands) if can_submit_commands
    end
  end

  define_aug_method!(:destroy) do |aug, resource|
    aug.rm(resource_path(resource))
  end


  def contactgroups
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/contactgroups")
      #debug("CG READER: #{s.split('/,/')}") if s
      #values = s.split(/,/) if s
      values = s.split(/,/) if s
    end
    #debug("CG READER VALUES: #{values}")
    values
  end

  def contactgroups=(value)
    debug("CONTACTGROUPS WRITER: #{value}")
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/contactgroups")
      else
        aug.set("#{resource_path}/contactgroups", value.join(','))
      end
    end
  end

  def custom
    augopen do |aug|
      c = {}
      aug.match("#{resource_path}/*").select { |m| File.basename(m).start_with?('_') }.each do |m|
        v = aug.get(m)
        c[File.basename(m)] = v
      end
      c
    end
  end

  def custom=(value)
    augopen! do |aug|
      # First, we need to remove all custom options
      aug.match("#{resource_path}/*").select { |m| File.basename(m).start_with?('_') }.each do |m|
        aug.rm(m)
      end

      if !value.empty?
        value.each do |k, v|
          aug.set("#{resource_path}/#{k}", "#{v}")
        end
      end
    end
  end

  attr_aug_accessor(:email,
                    :label => 'email',
                    :type => :string,
                   )

  attr_aug_accessor(:name,
                :label => 'name',
                :type => :string,
                :purge_ident => true,
               )

  attr_aug_accessor(:contact_name,
                    :label => 'contact_name',
                    :type => :string,
                   )

  attr_aug_accessor(:can_submit_commands,
                    :label => 'can_submit_commands',
                    :type => :string,
                   )

  attr_aug_accessor(:address1,
                    :label => 'address1',
                    :type => :string,
                   )

  attr_aug_accessor(:address2,
                    :label => 'address2',
                    :type => :string,
                   )

  attr_aug_accessor(:address3,
                    :label => 'address3',
                    :type => :string,
                   )

  attr_aug_accessor(:address4,
                    :label => 'address4',
                    :type => :string,
                   )

  attr_aug_accessor(:address5,
                    :label => 'address5',
                    :type => :string,
                   )

  attr_aug_accessor(:address6,
                    :label => 'address6',
                    :type => :string,
                   )

  #attr_aug_accessor(:contactgroups,
  #                  :label => 'contactgroups',
  #                  :type => :string,
  #                 )
  #attr_aug_reader(:contactgroups,
  #                  :label => 'contactgroups',
  #                  :type => :string,
  #                 )

  attr_aug_accessor(:host_notification_commands,
                    :label => 'host_notification_commands',
                    :type => :string,
                    :default => :undef,
                    :rm_node => true,
                   )

  attr_aug_accessor(:host_notification_options,
                    :label => 'host_notification_options',
                    :type => :string,
                   )

  attr_aug_accessor(:host_notification_period,
                    :label => 'host_notification_period',
                    :type => :string,
                   )

  attr_aug_accessor(:host_notifications_enabled,
                    :label => 'host_notifications_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:service_notification_commands,
                    :label => 'service_notification_commands',
                    :type => :string,
                   )

  attr_aug_accessor(:service_notification_options,
                    :label => 'service_notification_options',
                    :type => :array,
                    :split_by => ',',
                   )

  attr_aug_accessor(:service_notification_period,
                    :label => 'service_notification_period',
                    :type => :string,
                   )

  attr_aug_accessor(:service_notifications_enabled,
                    :label => 'service_notifications_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:pager,
                    :label => 'pager',
                    :type => :string,
                   )

  attr_aug_accessor(:retain_nonstatus_information,
                    :label => 'retain_nonstatus_information',
                    :type => :string,
                   )

  attr_aug_accessor(:retain_status_information,
                    :label => 'retain_status_information',
                    :type => :string,
                   )

  attr_aug_accessor(:register,
                    :label => 'register',
                    :type => :string,
                   )

  #attr_aug_accessor(:custom,
  #                  :label => '_',
  #                  :type => :array,
  #                  :purge_ident => true,
  #                 )
end
