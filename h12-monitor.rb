#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

if defined?(Bundler)
  Bundler.require
end

require 'daemons'
require File.expand_path('../lib/h12_monitor', __FILE__)

# You can get your API key from Heroku's My Account page
API_KEY = '--MY_API_KEY--'
APP_NAME = '--MY_APP_NAME--'

Daemons.run_proc('h12-monitor.rb') do
  H12Monitor.new(APP_NAME, API_KEY).monitor
end
