require 'rubygems'
require 'active_record'
require 'test/unit'

#unless defined? SPREE_ROOT
#  ENV["RAILS_ENV"] = "test"
#  require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/config/boot"
#end

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::INFO

require "#{File.expand_path(File.dirname(__FILE__) + "/../../../../")}/test/test_helper"

require "#{File.dirname(__FILE__)}/factories"

# test_helper.rb
class Test::Unit::TestCase # or class ActiveSupport::TestCase in Rails 2.3.x
  def without_timestamping_of(*klasses)
    if block_given?
      klasses.delete_if { |klass| !klass.record_timestamps }
      klasses.each { |klass| klass.record_timestamps = false }
      begin
        yield
      ensure
        klasses.each { |klass| klass.record_timestamps = true }
      end
    end
  end
end