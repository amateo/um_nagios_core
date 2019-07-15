# coding: utf-8
# Alternative Augeas-based providers for Puppet
#
# Copyright (c) 2019 Ángel L. Mateo (amateo@um.es)
# Licensed under the Apache License, Version 2.0


raise("Missing augeasproviders_core dependency") if Puppet::Type.type(:augeasprovider).nil?
Puppet::Type.type(:um_nagios_service).provide(:augeas, :parent => Puppet::Type.type(:augeasprovider).provider(:default)) do
  desc "Uses Augeas API to update an ssh_config parameter"

  default_file { '/etc/nagios/conf.d/services.cfg' }

  lens { 'Nagiosobjects.lns' }

  confine :feature => :augeas

  resource_path do |resource|
    if resource[:target]
      "/files/#{resource[:target]}/service[name = '#{resource[:name]}']"
    else
      "$target/service[name = '#{resource[:name]}']"
    end
  end


  def create
    path = resource_path
    augopen! do |aug|

      aug.set("#{path}/name", resource[:name])
      setvars(aug)
      attr_aug_writer_host_name(aug, resource[:host_name]) if resource[:host_name]
      self.hostgroup_name=(resource[:hostgroup_name]) if resource[:hostgroup_name]
      self.servicegroups=(resource[:servicegroups]) if resource[:servicegroups]
      self.contacts=(resource[:contacts]) if resource[:contacts]
      self.contact_groups=(resource[:contact_groups]) if resource[:contact_groups]
      attr_aug_writer_service_description(aug, resource[:service_description]) if resource[:service_description]
      attr_aug_writer_display_name(aug, resource[:display_name]) if resource[:display_name]
      attr_aug_writer_is_volatile(aug, resource[:is_volatile]) if resource[:is_volatile]
      attr_aug_writer_check_command(aug, resource[:check_command]) if resource[:check_command]
      attr_aug_writer_initial_state(aug, resource[:initial_state]) if resource[:initial_state]
      attr_aug_writer_max_check_attempts(aug, resource[:max_check_attempts]) if resource[:max_check_attempts]
      attr_aug_writer_check_interval(aug, resource[:check_interval]) if resource[:check_interval]
      attr_aug_writer_retry_interval(aug, resource[:retry_interval]) if resource[:retry_interval]
      attr_aug_writer_active_checks_enabled(aug, resource[:active_checks_enabled]) if resource[:active_checks_enabled]
      attr_aug_writer_passive_checks_enabled(aug, resource[:passive_checks_enabled]) if resource[:passive_checks_enabled]
      attr_aug_writer_check_period(aug, resource[:check_period]) if resource[:check_period]
      attr_aug_writer_obsess_over_service(aug, resource[:obsess_over_service]) if resource[:obsess_over_service]
      attr_aug_writer_check_freshness(aug, resource[:check_freshness]) if resource[:check_freshness]
      attr_aug_writer_freshness_threshold(aug, resource[:freshness_threshold]) if resource[:freshness_threshold]
      attr_aug_writer_event_handler(aug, resource[:event_handler]) if resource[:event_handler]
      attr_aug_writer_event_handler_enabled(aug, resource[:event_handler_enabled]) if resource[:event_handler_enabled]
      attr_aug_writer_low_flap_threshold(aug, resource[:low_flap_threshold]) if resource[:low_flap_threshold]
      attr_aug_writer_high_flap_threshold(aug, resource[:high_flap_threshold]) if resource[:high_flap_threshold]
      attr_aug_writer_flap_detection_enabled(aug, resource[:flap_detection_enabled]) if resource[:flap_detection_enabled]
      attr_aug_writer_flap_detection_options(aug, resource[:flap_detection_options]) if resource[:flap_detection_options]
      attr_aug_writer_process_perf_data(aug, resource[:process_perf_data]) if resource[:process_perf_data]
      attr_aug_writer_retain_status_information(aug, resource[:retain_status_information]) if resource[:retain_status_information]
      attr_aug_writer_retain_nonstatus_information(aug, resource[:retain_nonstatus_information]) if resource[:retain_nonstatus_information]
      attr_aug_writer_notification_interval(aug, resource[:notification_interval]) if resource[:notification_interval]
      attr_aug_writer_first_notification_delay(aug, resource[:first_notification_delay]) if resource[:first_notification_delay]
      attr_aug_writer_notification_period(aug, resource[:notification_period]) if resource[:notification_period]
      attr_aug_writer_notification_options(aug, resource[:notification_options]) if resource[:notification_options]
      attr_aug_writer_notifications_enabled(aug, resource[:notifications_enabled]) if resource[:notifications_enabled]
      attr_aug_writer_stalking_options(aug, resource[:stalking_options]) if resource[:stalking_options]
      attr_aug_writer_notes(aug, resource[:notes]) if resource[:notes]
      attr_aug_writer_notes_url(aug, resource[:notes_url]) if resource[:notes_url]
      attr_aug_writer_action_url(aug, resource[:action_url]) if resource[:action_url]
      attr_aug_writer_icon_image(aug, resource[:icon_image]) if resource[:icon_image]
      attr_aug_writer_icon_image_alt(aug, resource[:icon_image_alt]) if resource[:icon_image_alt]
      attr_aug_writer_use(aug, resource[:use]) if resource[:use]
      attr_aug_writer_register(aug, resource[:register]) if resource[:register]
      self.custom=(resource[:custom]) if resource[:custom]
    end
  end

  def hostgroup_name
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/hostgroup_name")
      values = s.split(/,/) if s
    end
    values
  end

  def hostgroup_name=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/hostgroup_name")
      else
        aug.set("#{resource_path}/hostgroup_name", value.join(','))
      end
    end
  end

  def servicegroups
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/servicegroups")
      values = s.split(/,/) if s
    end
    values
  end

  def servicegroups=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/servicegroups")
      else
        aug.set("#{resource_path}/servicegroups", value.join(','))
      end
    end
  end

  def contacts
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/contacts")
      values = s.split(/,/) if s
    end
    values
  end

  def contacts=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/contacts")
      else
        aug.set("#{resource_path}/contacts", value.join(','))
      end
    end
  end

  def contact_groups
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/contact_groups")
      values = s.split(/,/) if s
    end
    values
  end

  def contact_groups=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/contact_groups")
      else
        aug.set("#{resource_path}/contact_groups", value.join(','))
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

  attr_aug_accessor(:host_name,
                    :label => 'host_name',
                    :type => :string,
                   )

  attr_aug_accessor(:service_description,
                    :label => 'service_description',
                    :type => :string,
                   )

  attr_aug_accessor(:display_name,
                    :label => 'display_name',
                    :type => :string,
                   )

  attr_aug_accessor(:is_volatile,
                    :label => 'is_volatile',
                    :type => :string,
                   )

  attr_aug_accessor(:check_command,
                    :label => 'check_command',
                    :type => :string,
                   )

  attr_aug_accessor(:initial_state,
                    :label => 'initial_state',
                    :type => :string,
                   )

  attr_aug_accessor(:max_check_attempts,
                    :label => 'max_check_attempts',
                    :type => :string,
                   )

  attr_aug_accessor(:check_interval,
                    :label => 'check_interval',
                    :type => :string,
                   )

  attr_aug_accessor(:retry_interval,
                    :label => 'retry_interval',
                    :type => :string,
                   )

  attr_aug_accessor(:active_checks_enabled,
                    :label => 'active_checks_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:passive_checks_enabled,
                    :label => 'passive_checks_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:check_period,
                    :label => 'check_period',
                    :type => :string,
                   )

  attr_aug_accessor(:obsess_over_service,
                    :label => 'obsess_over_service',
                    :type => :string,
                   )

  attr_aug_accessor(:check_freshness,
                    :label => 'check_freshness',
                    :type => :string,
                   )

  attr_aug_accessor(:freshness_threshold,
                    :label => 'freshness_threshold',
                    :type => :string,
                   )

  attr_aug_accessor(:event_handler,
                    :label => 'event_handler',
                    :type => :string,
                   )

  attr_aug_accessor(:event_handler_enabled,
                    :label => 'event_handler_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:low_flap_threshold,
                    :label => 'low_flap_threshold',
                    :type => :string,
                   )

  attr_aug_accessor(:high_flap_threshold,
                    :label => 'high_flap_threshold',
                    :type => :string,
                   )

  attr_aug_accessor(:flap_detection_enabled,
                    :label => 'flap_detection_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:flap_detection_options,
                    :label => 'flap_detection_options',
                    :type => :string,
                   )

  attr_aug_accessor(:process_perf_data,
                    :label => 'process_perf_data',
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

  attr_aug_accessor(:notification_interval,
                    :label => 'notification_interval',
                    :type => :string,
                   )

  attr_aug_accessor(:first_notification_delay,
                    :label => 'first_notification_delay',
                    :type => :string,
                   )

  attr_aug_accessor(:notification_period,
                    :label => 'notification_period',
                    :type => :string,
                   )

  attr_aug_accessor(:notification_options,
                    :label => 'notification_options',
                    :type => :string,
                   )

  attr_aug_accessor(:notifications_enabled,
                    :label => 'notifications_enabled',
                    :type => :string,
                   )

  attr_aug_accessor(:stalking_options,
                    :label => 'stalking_options',
                    :type => :string,
                   )

  attr_aug_accessor(:notes,
                    :label => 'notes',
                    :type => :string,
                   )

  attr_aug_accessor(:notes_url,
                    :label => 'notes_url',
                    :type => :string,
                   )

  attr_aug_accessor(:action_url,
                    :label => 'action_url',
                    :type => :string,
                   )

  attr_aug_accessor(:icon_image,
                    :label => 'icon_image',
                    :type => :string,
                   )

  attr_aug_accessor(:icon_image_alt,
                    :label => 'icon_image_alt',
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
end
