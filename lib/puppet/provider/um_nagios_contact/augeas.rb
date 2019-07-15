# coding: utf-8
# Alternative Augeas-based providers for Puppet
#
# Copyright (c) 2019 Ángel L. Mateo (amateo@um.es)
# Licensed under the Apache License, Version 2.0


raise("Missing augeasproviders_core dependency") if Puppet::Type.type(:augeasprovider).nil?
Puppet::Type.type(:um_nagios_contact).provide(:augeas, :parent => Puppet::Type.type(:augeasprovider).provider(:default)) do
  desc "Uses Augeas API to update an ssh_config parameter"

  default_file { '/etc/nagios/conf.d/contacts.cfg' }

  lens { 'Nagiosobjects.lns' }

  confine :feature => :augeas

  resource_path do |resource|
    if resource[:target]
      "/files/#{resource[:target]}/contact[name = '#{resource[:name]}']"
    else
      "$target/contact[name = '#{resource[:name]}']"
    end
  end

  def create
    path = resource_path
    augopen! do |aug|

      aug.set("#{path}/name", resource[:name])
      setvars(aug)

      attr_aug_writer_contact_name(aug, resource[:contact_name]) if resource[:contact_name]
      attr_aug_writer_nagios_alias(aug, resource[:nagios_alias]) if resource[:nagios_alias]
      self.contactgroups=(resource[:contactgroups]) if resource[:contactgroups]
      attr_aug_writer_host_notifications_enabled(aug, resource[:host_notifications_enabled]) if resource[:host_notifications_enabled]
      attr_aug_writer_service_notifications_enabled(aug, resource[:service_notifications_enabled]) if resource[:service_notifications_enabled]
      attr_aug_writer_host_notification_period(aug, resource[:host_notification_period]) if resource[:host_notification_period]
      attr_aug_writer_service_notification_period(aug, resource[:service_notification_period]) if resource[:service_notification_period]
      attr_aug_writer_host_notification_commands(aug, resource[:host_notification_commands]) if resource[:host_notification_commands]
      attr_aug_writer_host_notification_options(aug, resource[:host_notification_options]) if resource[:host_notification_options]
      attr_aug_writer_service_notification_options(aug, resource[:service_notification_options]) if resource[:service_notification_options]
      attr_aug_writer_service_notification_commands(aug, resource[:service_notification_commands]) if resource[:service_notification_commands]
      attr_aug_writer_email(aug, resource[:email]) if resource[:email]
      attr_aug_writer_pager(aug, resource[:pager]) if resource[:pager]
      attr_aug_writer_address1(aug, resource[:address1]) if resource[:address1]
      attr_aug_writer_address2(aug, resource[:address2]) if resource[:address2]
      attr_aug_writer_address3(aug, resource[:address3]) if resource[:address3]
      attr_aug_writer_address4(aug, resource[:address4]) if resource[:address4]
      attr_aug_writer_address5(aug, resource[:address5]) if resource[:address5]
      attr_aug_writer_address6(aug, resource[:address6]) if resource[:address6]
      attr_aug_writer_can_submit_commands(aug, resource[:can_submit_commands]) if resource[:can_submit_commands]
      attr_aug_writer_retain_status_information(aug, resource[:retain_status_information]) if resource[:retain_status_information]
      attr_aug_writer_use(aug, resource[:use]) if resource[:use]
      attr_aug_writer_register(aug, resource[:register]) if resource[:register]
      self.custom=(resource[:custom]) if resource[:custom]
    end
  end

  attr_aug_accessor(:contact_name,
                    :label => 'contact_name',
                    :type => :string,
                   )

  attr_aug_accessor(:nagios_alias,
                    :label => 'alias',
                    :type => :string,
                   )

  def contactgroups
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/contactgroups")
      values = s.split(/,/) if s
    end
    values
  end

  def contactgroups=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/contactgroups")
      else
        aug.set("#{resource_path}/contactgroups", value.join(','))
      end
    end
  end

  attr_aug_accessor(:host_notifications_enabled,
                    :label => 'host_notifications_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:service_notifications_enabled,
                    :label => 'service_notifications_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:host_notification_period,
                    :label => 'host_notification_period',
                    :type => :string,
                   )

  attr_aug_accessor(:service_notification_period,
                    :label => 'service_notification_period',
                    :type => :string,
                   )

  attr_aug_accessor(:host_notification_commands,
                    :label => 'host_notification_commands',
                    :type => :string,
                   )

  attr_aug_accessor(:host_notification_options,
                    :label => 'host_notification_options',
                    :type => :string,
                   )

  attr_aug_accessor(:service_notification_options,
                    :label => 'service_notification_options',
                    :type => :string,
                   )

  attr_aug_accessor(:service_notification_commands,
                    :label => 'service_notification_commands',
                    :type => :string,
                   )

  attr_aug_accessor(:email,
                    :label => 'email',
                    :type => :string,
                   )

  attr_aug_accessor(:pager,
                    :label => 'pager',
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

  attr_aug_accessor(:can_submit_commands,
                    :label => 'can_submit_commands',
                    :type => :string,
                   )

  attr_aug_accessor(:retain_status_information,
                    :label => 'retain_status_information',
                    :type => :string,
                   )

  attr_aug_accessor(:retain_nonstatus_information,
                    :label => 'retain_nonstatus_information',
                    :type => :string,
                   )

  attr_aug_accessor(:use,
                    :label => 'use',
                    :type => :string,
                   )

  attr_aug_accessor(:register,
                    :label => 'register',
                    :type => :string,
                   )

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


end
