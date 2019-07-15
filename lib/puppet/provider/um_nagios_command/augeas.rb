# coding: utf-8
# Alternative Augeas-based providers for Puppet
#
# Copyright (c) 2019 Ángel L. Mateo (amateo@um.es)
# Licensed under the Apache License, Version 2.0


raise("Missing augeasproviders_core dependency") if Puppet::Type.type(:augeasprovider).nil?
Puppet::Type.type(:um_nagios_command).provide(:augeas, :parent => Puppet::Type.type(:augeasprovider).provider(:default)) do
  desc "Uses Augeas API to update an ssh_config parameter"

  default_file { '/etc/nagios/conf.d/commands.cfg' }

  lens { 'Nagiosobjects.lns' }

  confine :feature => :augeas

  resource_path do |resource|
    if resource[:target]
      "/files/#{resource[:target]}/command[name = '#{resource[:name]}']"
    else
      "$target/command[name = '#{resource[:name]}']"
    end
  end

  def create
    path = resource_path
    augopen! do |aug|

      aug.set("#{path}/name", resource[:name])
      setvars(aug)
      attr_aug_writer_command_name(aug, resource[:command_name]) if resource[:command_name]
      attr_aug_writer_command_line(aug, resource[:command_line]) if resource[:command_line]
      attr_aug_writer_use(aug, resource[:use]) if resource[:use]
      attr_aug_writer_register(aug, resource[:register]) if resource[:register]
      self.custom=(resource[:custom]) if resource[:custom]
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

  attr_aug_accessor(:command_name,
                   :label => 'command_name',
                   :type => :string,
                  )

  attr_aug_accessor(:command_line,
                   :label => 'command_line',
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
