#!/usr/bin/env ruby

require_relative 'lib/my_package'

pkg = MyPackage.new
arg = ARGV[0]

unless arg.nil?
  pkg.send(arg)
else
  pkg.prepare
  pkg.build
  pkg.publish
end
