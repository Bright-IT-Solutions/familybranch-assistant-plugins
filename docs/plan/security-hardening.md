# Plugin security implementation plan

Baseline: `fba4a88`, plugin version `1.0.0`. Complete these four fixes before the next plugin release. The packaging changes and the skill changes can be developed independently.

## 1. Build the OpenAI ZIP from reviewed files

**Files:** `bin/check`, `bin/package_openai`, and the release instructions in `README.md`.

1. Define one explicit inventory for the OpenAI package. It currently consists of `plugin.json`, `mcp.json`, `assets/icon.png`, and one `SKILL.md` under each of `skills/build-family-tree/`, `skills/keep-family-records/`, and `skills/make-a-poster/`. A new shipped file requires a reviewed inventory change.
2. In `bin/check`, inspect each package and canonical skills root and each entry with `lstat` before descending or reading. Reject symlinks and special files, including directory symlinks. Run this check before reading frontmatter or comparing copies. Reject missing and unexpected package files with a diagnostic naming the path.
3. Keep `bin/check` usable on in-progress edits. For `bin/package_openai`, resolve the release commit once, stage its contents in a temporary directory, and validate that snapshot. Read the version and archive inputs from the same snapshot. Document that maintainers commit release edits before building and print the commit used.
4. Archive only inventory paths. Verify ZIP integrity, exact file membership, absence of duplicate names, and equality of archived bytes with staged files. Create the ZIP under a temporary name in `dist/` and rename it to the versioned output only after verification succeeds.

**Acceptance:** A clean build produces the six expected files at their existing paths. A harmless untracked file in the developer checkout never reaches the archive. A snapshot with an unexpected tracked file or a missing expected file fails. File and directory symlink fixtures fail before their targets are read. A failed build leaves any previously verified ZIP intact. Run these checks in temporary repositories.

## 2. Enforce the Claude plugin’s declared capabilities

**Files:** `bin/check`, using `claude/.claude-plugin/plugin.json` and `claude/.mcp.json` as the supported configuration.

1. Allow only the Claude manifest keys used for this release: `name`, `displayName`, `version`, `description`, `author`, `homepage`, `privacyPolicyUrl`, `repository`, `license`, `keywords`, and `icon`. Retain the existing field checks and require the icon to resolve to the approved packaged asset.
2. Require the MCP configuration to contain exactly the named `familybranch` server with its existing HTTP transport and HTTPS endpoint. Extend the inventory check from step 1 to the Claude package, covering its manifest, MCP configuration, README, license, icon, and three shipped skills. This also catches components discovered by filename.
3. Apply these repository checks whether or not the optional Claude CLI is installed. When installed, require its validator process to exit successfully and surface its diagnostics on failure.

**Acceptance:** The shipped package passes. In disposable fixtures, an added manifest component field, an extra server, a changed endpoint, and an unexpected component file each fail with a diagnostic naming the offending key or path. Run the repository checks with the CLI absent as well as with it installed.

## 3. Apply living-person consent when saving record notes

**Files:** `skills/keep-family-records/SKILL.md` and its two generated copies.

1. Use the existing `get_person` result before `append_note`. Match the living-person rule in `build-family-tree`: names, relationships, dates and places can be recorded as requested. For additional personal details, including health, home addresses and contact details, show the proposed text and obtain approval before saving it to the shared tree. If living status is unclear, resolve it or omit the sensitive detail.
2. Keep identity-document numbers out of saved notes even after confirmation. Keep the existing upload-link flow for a living person’s documents.

**Acceptance:** Use synthetic records and inspect tool-call order. A general request to save a record containing a living person’s health detail produces a proposed note and no sensitive write until approval. Declining results in no sensitive write. An ordinary deceased-person source summary still works, and an identity-document number is omitted in both flows.

## 4. Require informed approval for overwrites

**Files:** `skills/build-family-tree/SKILL.md`, its two generated copies, and the corresponding descriptions in `README.md` and `claude/README.md`.

1. Resolve the person and inspect the current field before a write that could replace or clear an existing value. For parent changes, identify both the existing and proposed parent by name and disambiguate as needed.
2. If the user has already explicitly approved that specific replacement for that person, proceed. Otherwise show the person, field, current value, and proposed value, then wait for approval before calling `update_person`. Apply this to relationship edits made while connecting existing relatives as well as to the correction workflow.
3. Align both README descriptions with this behavior. Preserve the existing per-person deletion confirmation and append-only default for notes.

**Acceptance:** With synthetic profiles, an ambiguous parent correction pauses before any write. Approval produces one update to the intended person. A refusal produces none. An explicit request naming the person and the exact old and new values proceeds without a redundant prompt. Adding a value to an empty field still works.

## Release verification

Run `bin/sync_skills` after editing the canonical skills. Update the version in both manifests and the OpenAI release notes, then run `bin/check` and the packaging regression checks. Exercise the two skill scenarios on both assistant platforms with synthetic profiles or stubbed tools. Record the observed calls, since byte-for-byte skill synchronization alone cannot verify assistant behavior. Build the final ZIP from the reviewed release commit and record its commit ID and SHA-256 digest alongside the release.
