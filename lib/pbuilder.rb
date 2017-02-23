require_relative 'my_ensure'

class Pbuilder
  attr_reader :cache

  def initialize
    @cache = '/var/cache/pbuilder'
    MyEnsure.dir(@cache)
  end

  def run(distribution)
    MyEnsure.system("sudo -H pdebuild -- --basetgz #{@cache}/#{distribution}.tgz --use-network yes")
  end
end
