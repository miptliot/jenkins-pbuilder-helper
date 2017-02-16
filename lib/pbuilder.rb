require_relative 'my_ensure'

class Pbuilder
  attr_reader :cache

  def initialize
    @cache = '/var/cache/pbuilder'
    MyEnsure.dir(@cache)
  end

  def run
    # FIXME: pass 'debian8' from outside
    MyEnsure.system("sudo -H pdebuild -- --basetgz #{@cache}/debian8.tgz --use-network yes")
  end
end
