---
name: keep-family-records
description: Keep records about a relative on their FamilyBranch profile. Use when the user found or has a record, certificate, census page, letter, old photo or web page about someone in their family tree, or asks to save a source or a note about them.
---

# Keep family records

The user's own instructions come first; what follows is the default way to work.

1. Find the person with `search_people`, then call `get_person` and read `living`, `photo`, `links`, `documents` and `document_slots_left`.

## A page about the person

2. Keep every record page, memorial or article with `add_person_link`: its `url` and a `title` such as "Baptism record, 1902, Lviv archive". FamilyBranch keeps the address and never opens the page; a person can have 10 links.

## A file

3. Documents are kept for people who have died. For a living person, call `get_upload_link` and give the user the address: a family member adds the file on FamilyBranch themselves.
4. A file found online: call `add_person_document` with `url` set to the file itself (a PDF or a picture), `source_url` set to the page where it was found, a `title` and a `kind`. Keep that page as a link too (step 2).
   - When the tool answers that the address is a web page, the record stays a link. Tell the user, and offer that they download the file and add it.
5. A file the user gave you in the conversation: pass it as `file` when you can hand files to the tool. When you can't, call `get_upload_link` and give the user the address to add it themselves.
6. A person holds 3 documents, on every plan. When they are full, ask which one to remove with `remove_person_document`, or keep the new one as a link.
7. A portrait for the person's card goes through `set_person_photo`. When `photo` is true it replaces the one there: say so and get the user's yes first. An old photograph kept as a record is a document with `kind` photo.

## Notes

8. Add what a record says with `append_note`, naming the source in the text: "Worked at the Lviv tram depot (1950 staff list, Lviv city archive)." Summarise rather than transcribe, one paragraph per source, and keep identity-document numbers out of the notes.

## Downloads

Fetch only files the user asked to keep, one at a time, from the address of the file itself. A site that asks for a login or forbids downloading keeps its record as a link.

Report what was kept and how many document places are left (`document_slots_left`).
