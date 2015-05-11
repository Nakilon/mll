require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Append TODO-list to README.md"
task :todo do |t|
  fail unless File.exist? "README.md"
  File.open("README.md", "r+") do |readme_file|
    # begin readme_file.gets end until $_[/^## TODO/]
    readme_file.gets "## TODO"
    readme_file.gets
    %w{ lib/mll.rb spec/_spec.rb }.each do |file|
      readme_file.puts "", "#### #{file}", "", "```"
      stack = []
      lines = []
      File.foreach(file).with_index do |line, i|
        next unless shift = /\S/ =~ line
        depth = shift / 2
        stack[depth] = i
        lines |= stack.take(depth + 1) if line[/^\s*# TODO/]
      end
      next_line_to_print = lines.shift
      File.foreach(file).with_index do |line, i|
        next unless i == next_line_to_print
        readme_file.puts line
        next_line_to_print = lines.shift
      end
      readme_file.puts "```"
    end
  end
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

task :default => %w{ todo spec }
