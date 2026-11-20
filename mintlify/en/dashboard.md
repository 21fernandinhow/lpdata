---
title: Dashboard
description: Change the text, links, and images of your Landing Pages without coding.
---

# Edit with the Dashboard

In the [Dashboard](https://dashboard.lpdata.io), you change the content of your Landing Pages, such as text, numbers, links, and images, without coding. The Dashboard is in Portuguese. This page shows its labels as they appear on screen, with the English meaning in parentheses.

Open a Landing Page and click the **Conteúdo** (Content) tab. Above the content, the **Formulário** (Form) and **JSON** buttons switch the way you edit:

- **Form**: fields to fill in, like a sign-up form. It is the easiest way.
- **JSON**: the content as code, for people who program.

Both show the same content. You can switch between them at any time, and anything you have not saved stays there. The page opens in the Form. A Landing Page that is still empty opens in the JSON.

## Save

To save, click the floppy disk icon, on the right, above the content. You can also use the shortcut `⌘S` on a Mac or `Ctrl+S` on Windows.

A dot on the floppy disk icon tells you there are unsaved changes. If you try to leave the page before saving, the Dashboard asks whether you want to discard those changes.

If LPData does not accept the content, a message appears above the content and explains the problem. Click the message to go to the field with the problem.

## Form

The Form organizes the content in **sections** and **fields**:

- A **section** is a box that groups the fields of one part of the page. For example, the `hero` section can hold the title and the image at the top of the page. A section can have other sections inside it.
- A **field** is a piece of information you fill in, such as a title or a price.

Click a section's name to open or close the section. The main sections are already open.

Some sections are **lists**, such as a list of a product's benefits. The items of a list appear as **Item 1**, **Item 2**, and so on.

### Edit a field

Click the field, change its content, and save.

Each field has a **type**. The type appears next to the field's name and defines what you fill in:

| Type | What you fill in |
| --- | --- |
| `string` | A short, single-line text, such as a title |
| `text` | A long text that can have several lines |
| `number` | A number, such as a price |
| `boolean` | An on and off switch, such as showing or hiding a block |
| `url` | The address of a page, such as `https://example.com` |
| `hosted_file` | The address of a file stored in LPData, such as an image |
| `external_file` | The address of a file stored on another site, such as a video |

In a number field, if you delete the number or type something that is not a number, the field shows **Número inválido** (Invalid number). The Dashboard only keeps the number when it is correct.

### Create sections and fields

At the end of each section there are buttons that create something **inside** that section:

- **+ Campo** (Field) creates a field. Type the name, pick the type, and click **Adicionar** (Add). The field starts empty.
- **+ Seção** (Section) creates a section. Type the name and click **Adicionar** (Add). The new section starts empty and is already open.
- **+ Item**, in lists, creates a new item. The new item has the same fields as the first item, all empty.

At the end of the form, outside the sections, the **+ Campo** and **+ Seção** buttons create at the main level of the page.

Inside the same section, each field and each section needs a different name.

### Change a field's type

Click the type, next to the field's name, and pick another type. **Attention:** when you change the type, the Dashboard erases the field's content.

### Rename and remove

To the right of each field's and each section's name there are two icons:

- The **pencil** changes the name of the field or section.
- The **trash can** removes the field, the list item, or the whole section, with everything inside it.

List items only have the trash can, because they have no name.

The Dashboard asks for confirmation before renaming or removing.

**Attention:** talk to whoever maintains the site before renaming or removing. The site that shows this Landing Page looks for each field by its name. If a name changes or a field disappears, that part of the site can turn empty or stop working.

### Fields the Form does not edit

Sometimes a field shows only a message, with no place to edit. This happens when the content of that field is in a format the Form does not recognize. Ask whoever maintains the site to fix the field in the JSON. You can still rename or remove that field in the Form.

## JSON

The JSON mode shows the whole Content Document as text, with syntax highlighting and line numbers. It changes anything in the document, including the order of keys, which the Form does not reach.

- `Tab` indents. To leave the editor with the keyboard, press `Esc` and then `Tab`.
- `Enter` keeps the line's indentation.

Before sending, the Dashboard checks that the text is valid JSON and points to the line and column of the error. The content rules are the API's, described in [Content Document](/en/landing-pages#content-document). An error from those rules appears with the field path, such as `$.hero.title`, and leads to the matching line.

While the JSON is invalid, the Form is unavailable.
