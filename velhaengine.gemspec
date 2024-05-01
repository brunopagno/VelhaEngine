# frozen_string_literal: true

require_relative "lib/velhaengine/version"

Gem::Specification.new do |spec|
  spec.name = "velhaengine"
  spec.version = Velhaengine::VERSION
  spec.authors = ["Bruno Pagno"]
  spec.email = ["brunopagno@proton.me"]

  spec.summary = "Summary text here"
  spec.description = "Long description goes here :)"
  spec.homepage = "https://github.com/brunopagno/velhaengine"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/brunopagno/velhaengine"
  spec.metadata["changelog_uri"] = "https://github.com/brunopagno/velhaengine"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
