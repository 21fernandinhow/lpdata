---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Before closing the work, assess whether user-observable API or integration changes affect the public Mintlify docs in `mintlify/`. When they do, update the Portuguese and English pages together and run `mint validate` and `mint broken-links` from that directory. State the documentation impact in the closeout, including when no public-doc change is needed.

Once done, use /code-review to review the work.

Commit your work to the current branch.
