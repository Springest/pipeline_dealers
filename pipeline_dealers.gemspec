# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pipeline_dealers/version'

Gem::Specification.new do |gem|
  gem.name          = "pipeline_dealers"
  gem.version       = PipelineDealers::VERSION
  gem.authors       = ["Maarten Hoogendoorn"]
  gem.email         = ["maarten@springest.com"]
  gem.description   = %q{API client for PipelineDeals}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/Springest/pipeline_dealers"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "faraday", "~> 0.8.0"
  gem.add_dependency "faraday_middleware", "~> 0.9.0"
  gem.add_dependency "multi_json", "~> 1.0"

  gem.add_development_dependency "rspec", ">2"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "reek"
  gem.add_development_dependency "activesupport", "> 3.0.0"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "debugger"
  gem.add_development_dependency "rake"


  if RUBY_PLATFORM.include? "linux"
    gem.add_development_dependency "rb-inotify", "~> 0.8.8"
  elsif RUBY_PLATFORM.include? "darwin"
    gem.add_development_dependency "growl"
    gem.add_development_dependency "rb-fsevent"
  end
end
