require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/test/'
end
require 'pry-state'
require 'pry-byebug'
require "./lib/event_manager.rb"
require "./lib/sanitize_module.rb"
