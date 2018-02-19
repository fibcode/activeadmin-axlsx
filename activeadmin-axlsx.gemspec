require File.expand_path('../lib/active_admin/axlsx/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'activeadmin-axlsx'
  s.version = ActiveAdmin::Axlsx::VERSION
  s.author = 'Randy Morgan, Todd Hambley'
  s.email = 'digital.ipseity@gmail.com, thambley@tlcorporate.com'
  s.homepage = 'https://github.com/thambley/activeadmin-axlsx'
  s.platform = Gem::Platform::RUBY
  s.date = Time.now.strftime('%Y-%m-%d')
  s.license = 'MIT'
  s.summary = <<-SUMMARY
  Adds excel downloads for resources within the Active Admin framework via Axlsx.
  SUMMARY
  s.description = <<-DESC
  This gem uses axlsx to provide excel/xlsx downloads for resources in Active Admin.
  Often, users are happier with excel, so why not give it to them instead of CSV?
  DESC

  git_tracked_files = `git ls-files`.split("\n").sort
  gem_ignored_files = `git ls-files -i -X .gemignore`.split("\n")

  s.files = git_tracked_files - gem_ignored_files

  s.files       = `git ls-files`.split("\n").sort
  s.test_files  = `git ls-files -- {spec}/*`.split("\n")

  s.add_runtime_dependency 'activeadmin', '>= 0.6.6', '< 2'
  s.add_runtime_dependency 'axlsx', '~> 2.0'

  s.required_ruby_version = '>= 1.9.2'
  s.require_path = 'lib'
end
