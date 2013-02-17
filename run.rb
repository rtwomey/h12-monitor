#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'

if defined?(Bundler)
  Bundler.require
end

require File.expand_path('../lib/monitor', __FILE__)

# You can get your API key from Heroku's My Account page
API_KEY = '--MY_API_KEY--'
APP_NAME = '--MY_APP_NAME--'

Monitor.new(APP_NAME, API_KEY).monitor
