# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'steam_fi/version'

Gem::Specification.new do |spec|
  spec.name          = "steam_fi"
  spec.version       = SteamFi::VERSION
  spec.authors       = ["Laurynas Butkus"]
  spec.email         = ["laurynas.butkus@gmail.com"]
  spec.summary       = %q{steam.fi SMS gateway client}
  spec.homepage      = "https://github.com/laurynas/steam_fi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
