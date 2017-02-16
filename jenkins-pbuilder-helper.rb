#!/usr/bin/env ruby

require_relative 'lib/my_ensure'
require_relative 'lib/aptly'
require_relative 'lib/pbuilder'
require_relative 'lib/git_info'
require_relative 'lib/erb_renderer'

# ==== 1. check, collect and prepare all needed info =========================
MyEnsure.dir('debian/')

pbuilder = Pbuilder.new

aptly = Aptly.new(MyEnsure.env('aptly_prefix'), MyEnsure.env('aptly_distribution'))
aptly.ensure_repo

commit = GitInfo.new

build_number = MyEnsure.env('BUILD_NUMBER')
pkg_name = 'npoed-sso-edx'
pkg_version = [commit.time, commit.hash, build_number].join('~')
pkg_arch = 'amd64'

# we need to copy ssh key since we going to use chroot environment to build
if ENV.has_key?('git_ssh_key')
  MyEnsure.install(ENV['git_ssh_key'], "debian/git_ssh_key", :mode => 0600, :verbose => true)
end

# ==== 2. generate changelog =================================================
ERBRenderer.new('debian/changelog').generate({
  :version         => pkg_version,
  :date            => commit.rfc_date,
  :changelog_lines => commit.changelog_lines,
})

# ==== 3. build ==============================================================
pbuilder.run

# ==== 4. publish to repository ==============================================
result = "#{pbuilder.cache}/result/#{pkg_name}_#{pkg_version}_#{pkg_arch}.deb"
MyEnsure.file(result)
aptly.add(result)
