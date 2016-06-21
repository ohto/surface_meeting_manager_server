require 'rubygems' unless defined? ::Gem
require File.join(__dir__, 'app')
set :views, File.join(__dir__, 'views')
run Sinatra::Application

