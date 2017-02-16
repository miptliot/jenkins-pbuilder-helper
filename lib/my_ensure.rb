require 'fileutils'
require_relative 'notify'

class MyEnsure
  def self.dir(path)
    unless File.directory?(path)
      Notify.fatal("#{path}: dir not found")
    end
  end

  def self.file(path)
    unless File.file?(path)
      Notify.fatal("#{path}: file not found")
    end
  end

  def self.system(*args)
    if Kernel.system(*args) != true
      Notify.fatal("#{args.join(' ')}: returned error")
    end
  end

  def self.backticks(cmd)
    output = `#{cmd}`
    if $?.exitstatus != 0
      Notify.fatal("#{cmd}: returned error")
    end

    output
  end

  def self.env(var)
    unless ENV.has_key?(var)
      Notify.fatal("#{var}: should be defined in the environment")
    end

    ENV[var]
  end

  def self.install(src, dst, opts = {})
    begin
      FileUtils.install(src, dst, opts)
    rescue Exception => e
      Notify.fatal(e)
    end
  end
end
