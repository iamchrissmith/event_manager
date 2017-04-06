require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/test/'
end
require 'pry'
require "./lib/event_manager.rb"
require "./lib/sanitize_module.rb"
