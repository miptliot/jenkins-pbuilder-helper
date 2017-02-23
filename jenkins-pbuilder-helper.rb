#!/usr/bin/env ruby

require_relative 'lib/my_package'

pkg = MyPackage.new
pkg.prepare
pkg.build
pkg.publish
