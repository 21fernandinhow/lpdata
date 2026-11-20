---
title: Dashboard
description: Edit your Landing Pages' Content Document without a terminal, through the form or the JSON.
---

# Edit with the Dashboard

The [Dashboard](https://dashboard.lpdata.io) is the application where you edit your Landing Pages' Content Document without calling the API by hand. It uses the same management routes described in [Landing Pages](/en/landing-pages), with your account. The Dashboard interface is in Portuguese; the labels below are shown as they appear in it.

When you open a Landing Page, the **Conteúdo** (Content) tab shows the document in two modes: **Formulário** (Form) and **JSON**. Both edit the same document, so you can switch between them at any time without losing unsaved changes. The Dashboard opens in the Form; an empty document opens in the JSON.

## Save

Save with the floppy disk icon or with `⌘S` (`Ctrl+S` outside the Mac). A dot on the icon marks unsaved changes. The document is always written whole, as in the [update PATCH](/en/landing-pages#update).

If you try to leave the Landing Page with unsaved changes, the Dashboard asks for confirmation. Reloading or closing the tab shows the browser's warning.

When the API rejects the document, the errors appear above the editor with the field path, such as `$.hero.title`. Click an error to go to the field.

## Form

The Form shows each Editable Field with the editor for its `type`, without JSON:

| `type` | Editor |
| --- | --- |
| `string` | Single-line text |
| `text` | Multi-line text |
| `number` | Number |
| `boolean` | Switch |
| `url`, `external_file`, `hosted_file` | Address |

Sections appear nested, with the key as their title. The first level opens by default; the others open on click. List items appear as **Item 1**, **Item 2**, and so on.

### Create sections and fields

The footer of each section holds the buttons that create inside it:

- **Campo** (Field) asks for the name and the `type`. The value starts empty: `""`, `0`, or `false`.
- **Seção** (Section) asks for the name and creates an empty section.
- **Item**, in lists, adds an item with the same structure as the first one and empty values.

The buttons at the end of the form create at the document's first level. Two equal keys in the same section are not allowed.

### Change the type, rename, and remove

- Each field's `type` appears next to its name and can be changed. Changing the type clears the value and leaves the new type's empty value.
- The pencil renames a field or a section; the key keeps its position.
- The trash can removes a field, a whole section, or a list item.

Renaming or removing a key changes the structure your consumer application reads. LPData does not notify the application: update its code along with it.

### Fields the Form does not edit

A value outside an Editable Field, an unknown `type`, or a value that does not match its `type` appears as read-only, with the reason. Fix those in the JSON; the Form still lets you rename or remove the key.

## JSON

The JSON mode shows the whole Content Document as text, with syntax highlighting and line numbers. It changes anything in the document, including the order of keys, which the Form does not reach.

- `Tab` indents. To leave the editor with the keyboard, press `Esc` and then `Tab`.
- `Enter` keeps the line's indentation.

Before sending, the Dashboard checks that the text is valid JSON and points to the line and column of the error. The content rules are the API's, described in [Content Document](/en/landing-pages#content-document); an error from them appears with the field path and leads to the matching line.

While the JSON is invalid, the Form is unavailable.
