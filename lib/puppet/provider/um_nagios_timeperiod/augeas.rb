# coding: utf-8
# Alternative Augeas-based providers for Puppet
#
# Copyright (c) 2019 Ángel L. Mateo (amateo@um.es)
# Licensed under the Apache License, Version 2.0


raise("Missing augeasproviders_core dependency") if Puppet::Type.type(:augeasprovider).nil?
Puppet::Type.type(:um_nagios_timeperiod).provide(:augeas, :parent => Puppet::Type.type(:augeasprovider).provider(:default)) do
  desc "Uses Augeas API to update an ssh_config parameter"

  default_file { '/etc/nagios/conf.d/timeperiods.cfg' }

  lens { 'Nagiosobjects.lns' }

  confine :feature => :augeas

  resource_path do |resource|
    if resource[:target]
      "/files/#{resource[:target]}/timeperiod[name = '#{resource[:name]}']"
    else
      "$target/timeperiod[name = '#{resource[:name]}']"
    end
  end

  def create
    path = resource_path
    augopen! do |aug|

      aug.set("#{path}/name", resource[:name])
      setvars(aug)
      attr_aug_writer_timeperiod_name(aug, resource[:timeperiod_name]) if resource[:timeperiod_name]
      attr_aug_writer_nagios_alias(aug, resource[:nagios_alias]) if resource[:nagios_alias]
      self.sunday=(resource[:sunday]) if resource[:sunday]
      self.monday=(resource[:monday]) if resource[:monday]
      self.tuesday=(resource[:tuesday]) if resource[:tuesday]
      self.wednesday=(resource[:wednesday]) if resource[:wednesday]
      self.thursday=(resource[:thursday]) if resource[:thursday]
      self.friday=(resource[:friday]) if resource[:friday]
      self.saturday=(resource[:saturday]) if resource[:saturday]
      self.exclude=(resource[:exclude]) if resource[:exclude]
      attr_aug_writer_use(aug, resource[:use]) if resource[:use]
      attr_aug_writer_register(aug, resource[:register]) if resource[:register]
      self.custom=(resource[:custom]) if resource[:custom]
    end
  end

  def sunday
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/sunday")
      values = s.split(/,/) if s
    end
    values
  end

  def sunday=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/sunday")
      else
        aug.set("#{resource_path}/sunday", value.join(','))
      end
    end
  end

  def monday
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/monday")
      values = s.split(/,/) if s
    end
    values
  end

  def monday=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/monday")
      else
        aug.set("#{resource_path}/monday", value.join(','))
      end
    end
  end

  def tuesday
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/tuesday")
      values = s.split(/,/) if s
    end
    values
  end

  def tuesday=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/tuesday")
      else
        aug.set("#{resource_path}/tuesday", value.join(','))
      end
    end
  end

  def wednesday
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/wednesday")
      values = s.split(/,/) if s
    end
    values
  end

  def wednesday=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/wednesday")
      else
        aug.set("#{resource_path}/wednesday", value.join(','))
      end
    end
  end

  def thursday
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/thursday")
      values = s.split(/,/) if s
    end
    values
  end

  def thursday=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/thursday")
      else
        aug.set("#{resource_path}/thursday", value.join(','))
      end
    end
  end

  def friday
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/friday")
      values = s.split(/,/) if s
    end
    values
  end

  def friday=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/friday")
      else
        aug.set("#{resource_path}/friday", value.join(','))
      end
    end
  end

  def saturday
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/saturday")
      values = s.split(/,/) if s
    end
    values
  end

  def saturday=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/saturday")
      else
        aug.set("#{resource_path}/saturday", value.join(','))
      end
    end
  end

  def exclude
    values = []
    augopen do |aug|
      s = aug.get("#{resource_path}/exclude")
      values = s.split(/,/) if s
    end
    values
  end

  def exclude=(value)
    augopen! do |aug|
      if value.empty? then
        aug.rm("#{resource_path}/exclude")
      else
        aug.set("#{resource_path}/exclude", value.join(','))
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

  attr_aug_accessor(:timeperiod_name,
                   :label => 'timeperiod_name',
                   :type => :string,
                  )

  attr_aug_accessor(:nagios_alias,
                   :label => 'alias',
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
