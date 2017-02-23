require_relative 'my_ensure'
require_relative 'pbuilder'
require_relative 'git_info'
require_relative 'aptly'
require_relative 'erb_renderer'
require_relative 'notify'

class MyPackage
  def initialize
    validate_dpkg_files

    @pbuilder = Pbuilder.new

    @aptly = Aptly.new(MyEnsure.env('aptly_prefix'), MyEnsure.env('aptly_distribution'))
    @aptly.ensure_repo

    @build_number = MyEnsure.env('BUILD_NUMBER')
    @commit = GitInfo.new

    @pkg_name = get_pkg_name
    @pkg_version = get_pkg_version
    @pkg_arch = get_pkg_arch
  end

  def prepare
    # we need to copy ssh key since we going to use chroot environment to build
    if ENV.has_key?('git_ssh_key')
      MyEnsure.install(ENV['git_ssh_key'], "debian/git_ssh_key", :mode => 0600, :verbose => true)
    end

    ERBRenderer.new('debian/changelog').generate({
      :version         => @pkg_version,
      :date            => @commit.rfc_date,
      :changelog_lines => @commit.changelog_lines,
    })
  end

  def build
    @pbuilder.run(@aptly.distribution)
  end

  def publish
    result = File.join(@pbuilder.cache,
                       'result',
                       "#{@pkg_name}_#{@pkg_version}_#{@pkg_arch}.deb")
    MyEnsure.file(result)
    @aptly.add(result)
  end

  private

  def validate_dpkg_files
    MyEnsure.dir('debian/')
    MyEnsure.file('debian/control')
  end

  def get_pkg_name
    pkg_line = File.readlines('debian/control').find { |ln| ln =~ %r{^Package:\s+} }.to_s

    unless pkg_line =~ %r{^Package:\s+(\S+)$}
      Notify.fatal("can't find package name")
    end

    $1
  end

  def get_pkg_version
    [@commit.time, @commit.hash, @build_number].join('~')
  end

  def get_pkg_arch
    'amd64'   # FIXME
  end
end
