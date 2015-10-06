# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'c1/version'

Gem::Specification.new do |spec|
  spec.name          = "c1"
  spec.version       = C1::VERSION
  spec.authors       = ["Almaz Nazipov"]
  spec.email         = ["nazipov.almaz@gmail.com"]
  spec.summary       = %q{c1}
  spec.description   = %q{c1}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.2"
  
  spec.add_dependency "nokogiri", '~> 1.6.5'
  spec.add_dependency "rest-client"
end
