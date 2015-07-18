require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Append TODO-list to README.md"
task :todo do |t|
  fail unless File.exist? "README.md"
  File.open("README.md", "r+") do |readme_file|
    # begin readme_file.gets end until $_[/^## TODO/]
    readme_file.gets "### TODO"
    readme_file.gets
    %w{ lib/mll.rb spec/_spec.rb }.each do |file|
      readme_file.puts "", "#### #{file}", "", "```"
      stack = []
      File.foreach(file) do |line|
        next unless shift = /\S/ =~ line
        depth = shift / 2
        stack[depth] = line
        if line[/^\s*# TODO/]
          readme_file.puts stack.take(depth + 1).compact
          stack.clear
        end
      end
      readme_file.puts "```"
    end
    readme_file.truncate readme_file.pos
  end
  puts `md5 README.md`
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

task :default => %w{ spec todo }
