#
# Cookbook Name:: sphinx
# Recipe:: thinking_sphinx
#

# setup thinking sphinx on each app (see attributes)
node[:sphinx][:apps].each do |app_name|
  # paths
  current_path = "/data/#{app_name}/current"
  shared_path = "/data/#{app_name}/shared"
  
  # check that application is deployed
  if File.symlink?(current_path)
    # config yml
    template "/data/roombaby/shared/config/thinking_sphinx.yml" do
      source "thinking_sphinx.yml.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode "0644"
      backup 0
      variables({
        :environment => node[:environment][:framework_env],
        :address => node[:utility_instances].find{|i| i[:name] == 'megatron'}[:hostname]
      })
    end
    
    # configure thinking sphinx
    execute "configure sphinx" do 
      command "bundle exec rake ts:configure"
      user node[:owner_name]
      environment 'RAILS_ENV' => node[:environment][:framework_env]
      cwd current_path
    end
    
    # index unless index already exists
    execute "indexing" do
      command "bundle exec rake ts:index"
      user node[:owner_name]
      environment 'RAILS_ENV' => node[:environment][:framework_env]
      cwd current_path
    end
  else
    Chef::Log.info "Thinking Sphinx was not configured because the application (#{app_name}) must be deployed first. Please deploy your application and then re-run the custom chef recipes."
  end
end