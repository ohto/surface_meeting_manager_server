require 'rubygems' unless defined? ::Gem
require File.join(File.dirname(__FILE__), 'app')
run Sinatra::Application
