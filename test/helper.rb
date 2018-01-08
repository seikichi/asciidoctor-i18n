# coding: UTF-8

require 'coveralls'
require 'simplecov'

formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)
SimpleCov.start { add_filter('test') }
