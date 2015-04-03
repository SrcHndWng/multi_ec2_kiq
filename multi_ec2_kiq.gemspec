# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_ec2_kiq/version'

Gem::Specification.new do |spec|
  spec.name          = "multi_ec2_kiq"
  spec.version       = MultiEc2Kiq::VERSION
  spec.authors       = ["SrcHndWng"]
  spec.email         = [""]
  spec.summary       = "This gem starts multi ec2 instances, and stops them if you command."
  spec.description   = ""
  spec.homepage      = "https://github.com/SrcHndWng/multi_ec2_kiq"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"

  spec.add_runtime_dependency "settingslogic"
  spec.add_runtime_dependency "aws-sdk"
  spec.add_runtime_dependency "aws-sdk-core"
end
