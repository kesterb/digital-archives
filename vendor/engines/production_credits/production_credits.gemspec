$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "production_credits/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "production_credits"
  s.version     = ProductionCredits::VERSION
  s.authors     = ["Coding Zeal"]
  s.email       = ["contact@codingzeal.com"]
  s.homepage    = "http://codingzeal.com"
  s.summary     = "Summary of ProductionCredits."
  s.description = "Description of ProductionCredits."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.1.1"

  s.add_development_dependency "sqlite3"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency "faker"
end
