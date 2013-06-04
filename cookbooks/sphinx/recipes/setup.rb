#
# Cookbook Name:: sphinx
# Recipe:: setup
#

if util_or_app_server?(node[:sphinx][:utility_name]) 
  # report to dashboard
  ey_cloud_report "sphinx" do
    message "Setting up sphinx"
  end

  # monit
  execute "restart-sphinx" do
    command "monit reload && monit sleep 2s && monit restart sphinx"
    action :nothing
  end
  
  node[:sphinx][:apps].each do |app_name|
    # setup monit for each app defined (see attributes)
    template "/etc/monit.d/sphinx_#{app_name}.monitrc" do
      source "sphinx.monitrc.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode "0644"
      backup 0
      variables({
        :environment => node[:environment][:framework_env],
        :user => node[:owner_name],
        :app_name => app_name
      })
      notifies :run, resources(:execute => "restart-sphinx")
    end
  
    # indexing cron job
  end
end
