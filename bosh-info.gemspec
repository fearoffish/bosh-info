# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bosh/info/version'

Gem::Specification.new do |spec|
  spec.name          = "bosh-info"
  spec.version       = Bosh::Info::VERSION
  spec.authors       = ["Jamie van Dyke"]
  spec.email         = ["jamie@fearoffish.com"]
  spec.description   = %q{Grabs information on BOSH releases}
  spec.summary       = %q{Example: Diff the files in a bosh release and output in various formats}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "thor", "~> 0.18"
  spec.add_dependency "redcard"
  spec.add_dependency "interact"
  spec.add_dependency "easy_diff"

end
