require 'rubygems' unless defined? ::Gem
require File.join(__dir__, 'app')

run Sinatra::Application

