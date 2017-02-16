class Notify
  def self.info(msg)
    puts ['*** ', msg].join
  end

  def self.fatal(msg)
    STDERR.puts ['!!! ', msg].join
    exit 1
  end
end
