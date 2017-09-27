# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tfso/version"

Gem::Specification.new do |spec|
  spec.name          = "TFSO"
  spec.version       = TFSO::VERSION
  spec.authors       = ["Espen Antonsen"]
  spec.email         = ["espen@inspired.no"]

  spec.summary       = %q{Ruby API Wrapper for 24SevenOffice.}
  spec.homepage      = "https://github.com/espen/tfso"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
