$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "archive_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "archive_admin"
  s.version     = ArchiveAdmin::VERSION
  s.authors     = ["Coding Zeal"]
  s.email       = ["contact@codingzeal.com"]
  s.homepage    = "http://codingzeal.com"
  s.summary     = "Summary of ArchiveAdmin."
  s.description = "Description of ArchiveAdmin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "sqlite3"
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'uglifier', '>= 1.3.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'turbolinks'
  s.add_dependency 'sufia', '6.2.0'
  s.add_dependency 'rsolr', '~> 1.0.6'
  s.add_dependency 'devise'
  s.add_dependency 'devise-guests', '~> 0.3'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'web-console', '~> 2.0'
  s.add_development_dependency 'spring'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'jettywrapper'
  s.add_development_dependency "capybara"
  s.add_development_dependency "factory_girl_rails"
end
