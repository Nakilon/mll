require "bundler/gem_tasks"

task :default => %w{ spec todo }

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

desc "Generate TODO.md"
task :todo do |t|
  File.open("TODO.md", "w") do |readme_file|
    %w{ lib/mll.rb spec/_spec.rb }.each do |file|
      readme_file.puts "#### #{file}\n\n```"
      stack = []
      File.foreach(file) do |line|
        next unless shift = /\S/ =~ line
        next unless (stack[depth = shift / 2] = line)[/^\s*# TODO/]
        readme_file.puts stack.take(depth + 1).compact
        stack.clear
      end
      readme_file.puts "```\n\n"
    end
  end
  # puts `md5 TODO.md`
end
