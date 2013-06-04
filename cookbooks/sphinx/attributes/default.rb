#
# Cookbook Name:: sphinx
# Attrbutes:: default
#

default[:sphinx] = {
  # Sphinx will be installed on to application/solo instances,
  # unless a utility name is set, in which case, Sphinx will
  # only be installed on to a utility instance that matches
  # the name
  :utility_name => 'sphinx',
  
  # The version of sphinx to install
  :version => '2.0.6',
  
  # Applications that are using sphinx. Leave this blank to
  # setup sphinx for each app in an environment
  # :apps => ['todo', 'admin'],
  :apps => []
}


# set apps key to all available apps if empty
if default[:sphinx][:apps].empty?
  default[:sphinx][:apps] = node[:engineyard][:environment][:apps].map{|a| a[:name]}
end