#
# Cookbook Name:: overridable
# Provider:: repository
#
# Copyright 2011, Michael Leinartas
#

#XXX Should we respect the cookbook parameter or does it make sense to
# ignore it in the case of overrides?

action :nothing do
  action_create
end

action :create do
  cookbook_name = new_resource.cookbook || new_resource.cookbook_name
  cookbook = run_context.cookbook_collection[cookbook_name]

  template_override = nil
  file_override = nil

  if node['overridable']['template']['enabled'] and node['overridable']['template']['templates_enabled']
    begin
      template_override_path = ::File.join(new_resource.override_path,::File.basename(new_resource.source))
      filenames = cookbook.relative_filenames_in_preferred_directory(node, :templates, new_resource.override_path)
      if filenames.include? new_resource.source
      template_override = template_override_path
    rescue Chef::Exceptions::FileNotFound => e
    end
  end

  if node['overridable']['template']['enabled'] and node['overridable']['template']['files_enabled']
    begin
      file_override_path = ::File.basename(new_resource.path)
      cookbook.preferred_filename_on_disk_location(node, :files, file_override_path)
      file_override = file_override_path
    rescue Chef::Exceptions::FileNotFound => e
    end
  end

  if file_override
    file "#{new_resource.path}" do
      action (new_resource.only_if_missing ? :create_if_missing : :create)
      backup new_resource.backup if new_resource.backup
      cookbook new_resource.cookbook if new_resource.cookbook
      group new_resource.group if new_resource.group
      mode new_resource.mode if new_resource.mode
      owner new_resource.owner if new_resource.owner
      path new_resource.path if new_resource.path
      source file_override
    end
  else
    template "#{new_resource.path}" do
      action (new_resource.only_if_missing ? :create_if_missing : :create)
      backup new_resource.backup if new_resource.backup
      cookbook new_resource.cookbook if new_resource.cookbook
      group new_resource.group if new_resource.group
      local new_resource.local if new_resource.local
      mode new_resource.mode if new_resource.mode
      owner new_resource.owner if new_resource.owner
      path new_resource.path if new_resource.path
      variables new_resource.variables if new_resource.variables
      source template_override || new_resource.source
    end
  end
end

action :create_if_missing do
  new_resource.only_if_missing = true
  action_create
end
