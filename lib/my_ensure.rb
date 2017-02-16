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

  def system(*args)
    if system(*args) != true
      Notify.fatal("#{args.join(' ')}: returned error")
    end
  end

  def backticks(cmd)
    output = `#{cmd}`
    if $?.exitstatus != 0
      Notify.fatal("#{cmd}: returned error")
    end

    output
  end

  def env(var)
    unless ENV.has_key?(var)
      Notify.fatal("#{var}: should be defined in the environment")
    end

    ENV[var]
  end

  def cp(src, dst)
    begin
      FileUtils.cp(MyEnsure.env('git_ssh_key'), "debian/git_ssh_key", :verbose => true)
    rescue Exception => e
      Notify.fatal(e)
    end
  end
end
