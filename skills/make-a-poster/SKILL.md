---
name: make-a-poster
description: Make a printable FamilyBranch poster of a family tree. Use when the user asks for a poster, printout, PDF or picture of their tree, or a family-tree gift for a birthday, the winter holidays, Mother's Day or Father's Day.
---

# Make a poster

The user's own instructions come first; what follows is the default way to work.

1. Find the tree with `list_family_trees`.
2. Settle the choices. Ask only about those the request leaves open and that change the result:
   - `format`: pdf is one printable page; jpeg is a picture to share.
   - `style`: classic, heritage, minimal or night. Left out, the family's last style.
   - The **centre**, whom the sheet is drawn around: `centre_person_id` (find them with `search_people`), or a saved branch's `branch_id` from `get_family_tree`. Left out, the user's own card. A tree poster shows the centre's ancestors, descendants, partners and siblings; for another part of the family, centre on someone there.
   - `layout`: tree, or circles, rings of relatives around the centre.
   - `decoration`: birthday, mothers_day and fathers_day decorate the centre, so centre on the person celebrated; winter decorates the sheet's edges.
   - `title`: up to 80 characters. Left out, the tree's or the branch's name; a birthday, Mother's Day or Father's Day poster greets a living centre by name.
3. Call `create_poster_export`. It answers at once with an `export_id`; tell the user the poster takes a minute or so.
4. Call `get_export_status`. While its `status` is pending or processing, tell the user it is still being made and check again, a few times at most. When it is still not ready, give the user the `export_id` and say they can ask again later.
5. Completed: give the `download_url` and say it works for an hour; `get_export_status` gives a fresh one later. Failed: say so and offer to try again. A tree makes one poster at a time.

When `watermark` is true, the family's plan puts a small FamilyBranch mark on the sheet. Say so plainly if the user asks, and leave buying and upgrading out of the conversation.
