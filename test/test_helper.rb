ENV['RACK_ENV'] = 'test'
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'tfso'
require 'dotenv/load'
require "minitest/autorun"
