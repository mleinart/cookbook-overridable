#
# Cookbook Name:: overridable
# Resource:: repository
#
# Copyright 2011, Michael Leinartas
#

actions :create, :create_if_missing

# Validations copied here from File and Template resources so that
# stacktraces properly inform the user where the validation occurred
attribute :backup, :kind_of => [ Integer, FalseClass ]
attribute :checksum, :regex => /^[a-zA-Z0-9]{64}$/
attribute :cookbook, :kind_of => String
attribute :group, :kind_of => String
attribute :local, :kind_of => [ TrueClass, FalseClass ]
attribute :mode, :kind_of => String
attribute :only_if_missing, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :owner, :kind_of => String
attribute :path, :kind_of => String, :name_attribute => true
attribute :source, :kind_of => String, :default => "#{::File.basename(name)}.erb"
attribute :variables, :kind_of => Hash
