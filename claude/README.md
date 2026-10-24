# FamilyBranch

Build your family tree in [FamilyBranch](https://familybranch.live) from a
conversation with Claude. Name your relatives and how they are related, and
Claude adds them with the dates you know, even when you know only the year.
Keep birth records, census pages, letters and memorial pages on a relative's
profile, add what a record says to their notes with its source, and make a
printable PDF or JPEG poster of the tree.

## Use it

Install the plugin, then connect FamilyBranch from the plugin's Connectors
tab (in Claude Code, `/mcp`) and sign in with your FamilyBranch account. You
see which families Claude will reach and choose to allow it. Then ask, for
example:

- "Add my grandmother Nina, born around 1941 in Lviv, as my mother's mother."
- "Keep this birth record on my great-grandfather Petro's profile."
- "Make a PDF poster of my family tree in the Heritage style."

The plugin holds three skills, which teach Claude the way FamilyBranch works:

- **build-family-tree**: finds the right person before adding anyone, adds one
  generation at a time, records dates only as precisely as you give them, and
  asks before deleting someone or replacing what the tree holds.
- **keep-family-records**: keeps a record's page as a link and the record
  itself as a document, for people who have died, and names the source in the
  notes.
- **make-a-poster**: settles the format, style and the person in the middle,
  starts the poster and gives you its download link.

## Data

The plugin itself runs no code and stores nothing. It points Claude at one
server, `https://familybranch.live/mcp`, run by FamilyBranch. Through it,
Claude reads and changes the family trees your account belongs to, within
your role in each family; the family's admin can turn assistants off for the
family. When you ask Claude to keep a document or a photo from a web address,
the FamilyBranch server downloads that one file (a PDF or a picture, up to
20 MB) and stores it with the person's profile. You can disconnect Claude at
any time in FamilyBranch: your account menu, Connected assistants.

Privacy policy: https://familybranch.live/privacy. Support:
https://familybranch.live/assistants#support.
