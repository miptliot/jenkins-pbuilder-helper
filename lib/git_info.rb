require 'notify'

class GitInfo
  attr_reader :rfc_date, :time, :hash, :changelog_lines

  def initialize
    @rfc_date  = MyEnsure.backticks('git log -1 --format="%cD"').chomp
    @time      = MyEnsure.backticks('git log -1 --format="%ci"').split(/[\-: ]/)[0,5].join
    @hash      = MyEnsure.backticks('git log -1 --format="%h"').chomp

    @changelog_lines = MyEnsure.backticks('git log -16 --decorate=short --pretty="%ci  %h %d %s" --abbrev-commit').lines
  end
end
