# The files each package ships, and nothing else. bin/check refuses a
# package with one of them missing or with any other file in it, and
# bin/package_openai zips only these, so shipping a new file is a change
# here, reviewed like any other.
#
# Kept out on purpose: in claude/, components Claude would load or run, such
# as hooks/, commands/, agents/ or .lsp.json, and a top-level bin/, which
# stops claude.ai from installing the plugin at all; in openai/, .app.json,
# .mcp.json, .codex-plugin/ and hooks/, which the Agent Plugins package has
# no place for (the portal refuses a ZIP with apps or hooks).

SKILLS = %w[build-family-tree keep-family-records make-a-poster].freeze

INVENTORY = {
  # The skills' source, which bin/sync_skills copies into both packages
  "skills" => SKILLS.map { |name| "#{name}/SKILL.md" },
  "claude" => [".claude-plugin/plugin.json", ".mcp.json", "README.md", "LICENSE", "assets/icon.png",
    *SKILLS.map { |name| "skills/#{name}/SKILL.md" }],
  "openai" => ["plugin.json", "mcp.json", "assets/icon.png", *SKILLS.map { |name| "skills/#{name}/SKILL.md" }]
}.transform_values { |files| files.sort.freeze }.freeze
