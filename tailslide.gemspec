# frozen_string_literal: true

require_relative 'lib/tailslide/version'

Gem::Specification.new do |spec|
  spec.name = 'tailslide'
  spec.version = Tailslide::VERSION
  spec.authors = ['Steven Liou', 'Trent Cooper', 'Elaine Vuong', 'Jordan Eggers']
  spec.email = ['stevenliou@gmail.com', '00trent@protonmail.com', 'e.vuong94@gmail.com', 'jordan.shay.eggers@gmail.com']

  spec.summary = 'This is the Ruby SDK for Tailslide, which is a feature flag framework with automatic fail safe and circuit recovery.'
  spec.description = ' Write a longer description or delete this line.'
  spec.homepage = 'https://github.com/tailslide-io/tailslide.rb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'
  spec.add_runtime_dependency 'async', '~> 2.0.3'
  spec.add_runtime_dependency 'nats-pure', '~> 2.1.0'
  spec.add_runtime_dependency 'redis', '~> 4.7.1'
  spec.add_runtime_dependency 'redistimeseries', '~> 0.1.2'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tailslide-io/tailslide.rb'
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
