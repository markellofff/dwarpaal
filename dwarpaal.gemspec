# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dwarpaal/version'

Gem::Specification.new do |spec|
  spec.name          = "dwarpaal"
  spec.version       = Dwarpaal::VERSION
  spec.authors       = ["Ranu Pratap Singh"]
  spec.email         = ["singh.ranupratap@gmail.com"]
  spec.summary       = %q{Gem to prevent ddos.}
  spec.description   = %q{Gem to prevent ddos.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir.glob('lib/**/*.*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency     'rack', '>= 1.0.0'
  spec.add_runtime_dependency     'activerecord'
end
