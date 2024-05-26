require_relative "lib/twinkle/version"

Gem::Specification.new do |spec|
  spec.name        = "twinkle"
  spec.version     = Twinkle::VERSION
  spec.authors     = ["Tim Marks"]
  spec.email       = ["t@imothee.com"]
  spec.homepage    = "https://github.com/imothee/twinkle"
  spec.summary     = "Twinkle is a Rails engine for hosting appcast and collecting anonymous sparkle-project usage data."
  spec.description = "Twinkle is a Rails engine for hosting appcast and collecting anonymous sparkle-project usage data."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/imothee/twinkle"
  spec.metadata["changelog_uri"] = "https://github.com/imothee/twinkle/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.0.0"
end
