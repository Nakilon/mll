Gem::Specification.new do |spec|
  spec.name          = "mll"
  spec.version       = (require_relative "lib/mll"; MLL::VERSION)
  spec.authors       = ["Victor Maslov"]
  spec.email         = ["nakilon@gmail.com"]
  spec.summary       = "Mathematica Language Library in Ruby"
  spec.description   = ""
  spec.homepage      = "https://github.com/Nakilon/mll"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = ["spec/"]
  # spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12.0"
  # spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"

  spec.required_ruby_version = ">= 2.0.0"
  # spec.post_install_message = ""
end
