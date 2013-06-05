#
# Cookbook Name:: sphinx
# Recipe:: default
#

include_recipe "sphinx::install"
include_recipe "sphinx::thinking_sphinx"
include_recipe "sphinx::setup"
