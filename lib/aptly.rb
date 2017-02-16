require_relative 'notify'

class Aptly
  def initialize(prefix, distribution)
    @prefix = prefix
    @distribution = distribution
    @repo = [@prefix, @distribution].join('/')
  end

  def ensure_repo
    Notify.info("check aptly repo")
    unless run('repo', 'show', @repo)
      Notify.fatal("#{@repo}: invalid repo")
    end
  end

  def add(path)
    Notify.info("adding result to repo")

    unless run('repo', 'add', @repo, path)
      Notify.fatal("#{path}: unable to add to #{@repo}")
    end

    publish
  end

  def publish
    Notify.info("publishing/updating repo")

    unless run('publish', 'repo', @repo, @prefix)
      puts "#{@repo}: seems to be published already, trying to update"
      unless run('publish', 'update', @distribution, @prefix)
        Notify.fatal("#{@prefix}/@{@distribution}: filed to update published repo")
      end
    end
  end

  private

  def run(*args)
    system('sudo', '-Hu', 'aptly',
           'aptly', *args)
  end
end
