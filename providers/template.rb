#
# Cookbook Name:: overridable
# Provider:: repository
#
# Copyright 2011, Michael Leinartas
#

#XXX Should we respect the cookbook parameter or does it make sense to
# ignore it in the case of overrides?

action :create do
  cookbook_name = new_resource.cookbook || new_resource.cookbook_name
  cookbook = run_context.cookbook_collection[cookbook_name]

  template_override = nil
  file_override = nil

  unless node['overridable']['template']['disabled'] or node['overridable']['template']['templates_disabled']
    begin
      template_override_path = ::File.join(new_resource.override_path,::File.basename(new_resource.source))
      cookbook.relative_filenames_in_preferred_directory(node, :templates, template_override_path)
      template_override = template_override_path
    rescue Chef::Exceptions::FileNotFound => e
    end
  end

  unless node['overridable']['disabled'] or node['overridable']['files_disabled']
    begin
      file_override_path = ::File.basename(new_resource.path)
      cookbook.relative_filenames_in_preferred_directory(node, :files, file_override_path)
      file_override = file_override_path
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
      source "#{file_override}"
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
      variables new_resource.path if new_resource.variables
      source "#{template_override}" || new_resource.source
    end
  end
end

action :create_if_missing do
  new_resource.only_if_missing = true
  action_create
end