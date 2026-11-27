# FamilyBranch for ChatGPT and Claude

The plugin packages that bring [FamilyBranch](https://familybranch.live), the
family tree a family builds together, into ChatGPT and Claude. Both connect
to the same server, `https://familybranch.live/mcp`, and carry the same three
skills:

- **build-family-tree**: add relatives one generation at a time, with dates
  only as precise as the user gives them, and change or remove people with
  the user's yes.
- **keep-family-records**: keep record pages as links and records as
  documents on a relative's profile, with the source in the notes.
- **make-a-poster**: make a printable PDF or JPEG poster of the tree and hand
  over its download link.

## Layout

| Path | What it is |
| --- | --- |
| `skills/` | The skills' source. Edit them here, never in a package. |
| `claude/` | The Claude plugin: `.claude-plugin/plugin.json`, `.mcp.json`, its README (the directory listing's text), the licence, the icon and a copy of the skills. |
| `openai/` | The ChatGPT plugin in the Agent Plugins format: `plugin.json` with the listing and review details under `extensions.com.openai`, `mcp.json`, the icon and a copy of the skills. |
| `lib/inventory.rb` | Every file each package ships. A package holding any other file fails the checks, so shipping a new file starts here. |
| `bin/sync_skills` | Copies `skills/` and `LICENSE` into both packages. Copies, not symlinks: Claude's directory refuses symlinks. |
| `bin/check` | Holds both packages to the portals' rules (below) and runs `claude plugin validate ./claude` when Claude Code is installed. Works on the checkout as it is, uncommitted edits included. |
| `bin/package_openai` | Builds the ZIP for the OpenAI portal from a commit, never from the checkout. |
| `bin/test` | Regression tests for `bin/check` and `bin/package_openai`, run in temporary repositories. |

The scripts need Ruby 3 or later.

## Releasing a change

1. Edit `skills/`, then run `bin/sync_skills`.
2. Raise `version` in both `claude/.claude-plugin/plugin.json` and
   `openai/plugin.json`, and say what changed in
   `openai/plugin.json`'s `publication.release_notes`.
3. Run `bin/check` and `bin/test`.
4. When a skill's behaviour changed, try it on both assistants with made-up
   relatives and note the tool calls you saw: identical copies of a skill
   don't show what an assistant does with it.
5. Commit. The ZIP is built from a commit, so uncommitted edits are not in it.
6. Claude: push. The directory follows this repository's tracked branch or
   tag, plugin path `claude`. Try it first with
   `claude --plugin-dir ./claude`.
7. ChatGPT: `bin/package_openai` builds HEAD (`bin/package_openai <commit>`
   builds another). It stages the commit's files in a temporary folder, runs
   that commit's `bin/check` on them, zips only the files `lib/inventory.rb`
   lists for `openai/`, verifies the ZIP against the staged files, and only
   then names it `dist/familybranch-openai-<version>.zip`; a failed build
   leaves an earlier ZIP as it was. Keep the commit and SHA-256 it prints
   with the release, then upload the ZIP at platform.openai.com/plugins. A
   change to the server's tools needs no ZIP.

## What the checks hold

- Skills: frontmatter of `name` (the folder's, lowercase and hyphens) and a
  one-line `description` of at most 1,024 characters; instructions under 500
  lines; `familybranch:<skill>` at most 64 characters; no web addresses.
- First, before any file is read: `skills/` and both packages hold exactly
  the files `lib/inventory.rb` lists, each a regular file. Every entry is
  looked at without following links, so a symlink, to a file or a folder,
  or a special file such as a FIFO fails by name and is never opened.
- Both packages: skills identical to `skills/`; no file but an image over
  256 KiB; the same name, version and description; the server
  `https://familybranch.live/mcp`.
- Claude: only the manifest keys this release uses (`name`, `displayName`,
  `version`, `description`, `author`, `homepage`, `privacyPolicyUrl`,
  `repository`, `license`, `keywords`, `icon`), since any other key would
  declare hooks, commands, agents or servers; `.mcp.json` holding only the
  `familybranch` server, type `http`, at that address; a README of at least
  40 words outside code blocks; a licence; `./assets/icon.png` as the icon, a
  square PNG of 512 to 2,048 pixels, which the directory takes once, when the
  plugin is first saved there. When Claude Code is installed,
  `claude plugin validate` must also succeed; the other checks run either way.
- OpenAI: only the Agent Plugins manifest keys; no `apps` or hooks (the
  portal refuses a ZIP with either); display name and subtitle of at most 30
  characters; a portal category; https listing addresses; up to three
  starter prompts of at most 128 characters; a brand colour with 2:1 contrast
  against white; a square PNG logo and composer icon of 48 to 4,096 pixels;
  exactly five positive and three negative review cases, a case's files at
  https addresses; release notes; one server, `streamable-http`, OAuth by
  CIMD, with no headers.

`openai/mcp.json` puts the server's OAuth setting under
`extensions.com.openai`, as OpenAI's packaging guide does, although the
Agent Plugins MCP schema allows no extension on a server. The portal is the
judge; if it refuses the block, remove it, since the server's OAuth metadata
says the same.

## Data

The packages run no code and store nothing. They point the assistant at
FamilyBranch's server, which reads and changes the family trees the user's
account belongs to, within their role in each family, after the user signs
in and allows it. Privacy policy: https://familybranch.live/privacy.

## Licence

MIT, see `LICENSE`.
