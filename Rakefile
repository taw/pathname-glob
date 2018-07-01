task "default" => "spec"
task "test" => "spec"

desc "Run tests"
task "spec" do
  sh "rspec"
end

desc "Clean up"
task "clean" do
  sh "trash pathname-glob-*.gem"
end

desc "Build gem"
task "gem:build" do
  sh "gem build pathname-glob.gemspec"
end

desc "Upload gem"
task "gem:push" => "gem:build" do
  gem_file = Dir["pathname-glob-*.gem"][-1] or raise "No gem found"
  sh "gem", "push", gem_file
end
