Description
===========

The *overridable* cookbook provides an LWRP that makes it simple to provide
maximum user flexibility in cookbook templates. When used instead of the
standard Template resource (<http://wiki.opscode.com/display/chef/Resources#Resources-Template>),
it provides a means for a cookbook user to override each template with either
the user's own template or a concrete file.

Attributes
==========
* `node['overridable']['template']['enabled']` - Default: `true`. Setting to `false`
  passes through to the standard Template behavior
* `node['overridable']['template']['files_enabled']` - Default: `true`. Setting to `false`
  disables the ability to override from files
* `node['overridable']['template']['templates_enabled']` - Default: `true`. Setting to
  `false` disables the ability to override existing templates with new templates

Usage
=====

## Cookbook Authors
To use the LWRP in your cookbook, simply add `depends 'overridable'` to the
cookbook's *metadata.rb* and substitute any `template` resources
with `overridable_template`

## Cookbook Users
When config file customization is needed on a cookbook that takes advantage of
*overridable* template, two options are available:

### Custom template
Copy the cookbook's provided template file to a new file of the same name
within the cookbook's templates/overrides directory.
Ex: `templates/default/web_app.conf.erb` maps to `templates/default/overrides/web_app.conf.erb`
Additional attributes can be set in a new attributes file added to the cookbook
attributes/ directory and referenced through the `@node` reference exposed to
the Erb template. File-specificity rules are honored, so the `override/` path can
exist in a host-specific directory instead for instance.

### Custom file
A file can replace the template behavior entirely (ensure you have dealt with
any dynamic aspect of the config you're replacing). The file must be named
the same as the destination path of the template resource
Ex: `/etc/ntp.conf` would be named `ntp.conf` within the cookbook's files/
directory

Todo
====

* Multiple `overridable_template` calls that refer to the same base filename within
separate paths will all be overridden by the same file with no way to separate
them out
* Given the name of the cookbook, other wrappers could make sense as well (file?)

License and Author
==================

Author:: Michael Leinartas (<mleinartas@gmail.com>)

Copyright 2011, Michael Leinartas

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
