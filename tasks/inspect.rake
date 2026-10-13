# frozen_string_literal: true

require 'json'
require 'open3'

PLATFORM_LISTS_URL = 'https://raw.githubusercontent.com/OpenVoxProject/shared-actions/main/platforms.json'
# Paths with no bearing on a build. Any other path outside the project and
# component files builds every project.
IGNORED_PATHS = Regexp.union(
  %r{\A\.github/(?!workflows/runtime_tests\.yml)},
  %r{\A(ext|notes)/},
  %r{\Atasks/(?!build\.rake\z)},
  /\A(\.gitignore|\.rubocop\.yml|LICENSE|component_info\.json|generate\.rb)\z/,
  /\.md\z/
)

# Returns nil when git cannot resolve the range, as on a new branch or after
# a force push, so that every project gets built.
def changed_paths(base)
  output, status = Open3.capture2('git', 'diff', '--name-only', "#{base}...HEAD")
  status.success? ? output.lines(chomp: true) : nil
end

# Captures stdout alone, so a warning on stderr reaches the log and not the parser.
def vanagon(arguments)
  output, status = Open3.capture2("bundle exec vanagon #{arguments}")
  abort "Vanagon failed, arguments were #{arguments}" unless status.success?

  output
end

# Every platform gets inspected, which fails the task on a broken config, but
# only the platforms the PR builds decide which components matter.
def inspect_components(project, vanagon_platforms, build_platforms)
  vanagon_platforms.flat_map do |platform|
    puts "Inspecting #{project} on #{platform}"
    names = JSON.parse(vanagon("inspect #{project} #{platform}")).map { |component| component['name'] }
    build_platforms.include?(platform) ? names : []
  end
end

def affects?(path, project, components)
  return false if path.match?(IGNORED_PATHS)

  name = path[%r{\Aconfigs/(?:projects|components)/([^_/][^/]*)\.(?:rb|json)\z}, 1]
  name.nil? || name == project || components.include?(name)
end

# PR checks leave out macOS and Windows for time. The openbolt projects have
# no redhatfips or el-7 builds, the same rule the shared build workflow
# applies to its default list.
def build_platforms_for(project, platform_lists)
  branch = project[/-(\d+\.x)\z/, 1] || 'main'
  skip = project.start_with?('openbolt') ? /\A(macos|windows|redhatfips|el-7)-/ : /\A(macos|windows)-/
  platform_lists.fetch(branch).fetch('vanagon').grep_v(skip)
end

namespace :vox do
  desc 'Inspect every project on every platform and print the build matrix for the projects a change affects'
  task :inspect, [:base] do |_task, args|
    platform_lists = JSON.parse(http(PLATFORM_LISTS_URL))
    changed = changed_paths(args[:base])
    vanagon_platforms = vanagon('list --platforms').lines(chomp: true).drop(1)
    matrix = Dir['configs/projects/[a-z]*.rb'].filter_map do |path|
      project = File.basename(path, '.rb')
      build_platforms = build_platforms_for(project, platform_lists)
      components = inspect_components(project, vanagon_platforms, build_platforms)
      next unless changed.nil? || changed.any? { |changed_path| affects?(changed_path, project, components) }

      { 'project_name' => project, 'platform_list' => build_platforms.join(',') }
    end
    puts "Runtimes to build: #{JSON.generate(matrix)}"
    File.write(ENV['GITHUB_OUTPUT'], "build_matrix=#{JSON.generate(matrix)}\n", mode: 'a') if ENV['GITHUB_OUTPUT']
  end
end
