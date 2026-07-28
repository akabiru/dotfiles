# Commenting Hygiene

How to decide whether a code comment should exist, and how to write it if it should. Applies to every comment syntax: `#`, `//`, `/** */`, `<!-- -->`, in any language.

## The workflow

Before writing or editing any code comment, work through these in order. Don't wait to be reminded; make it a reflex whenever you touch a comment.

1. **Should this comment exist at all?** (threshold)
2. If yes, **write the principle, not the mechanics.** (altitude)
3. **Describe the present, not the journey.** (framing)
4. **Skip framework conventions and jargon.** (noise)

Draft once applying all four, then do a revision pass scanning for the violations listed below.

---

## 1. Default to no comment

The bar for a comment to exist is high. Default to writing none. A comment earns its place only when:

- the code is **not obviously readable** to someone fluent in the stack, or
- it needs **special context** the reader cannot derive from the code itself or its tests: a non-obvious external dependency, a footgun, a real constraint.

"Load-bearing WHY" and cross-file coupling do **not** automatically justify a comment. Cut them if the code reads clearly to a fluent reader. If a test already documents the why (through its name or a short in-test note), prefer that over a production-code comment. When unsure, omit and let the diff and tests speak.

Ask first: "does this need a comment AT ALL?" - before "is it the right altitude?". Lean to no.

## 2. Lead with the principle, strip the mechanics

When a comment is justified, ask "what would a tech lead want to know?" Lead with the principle and motivation: _why this exists_ and _what convention it documents_, in one or two sentences.

Then strip every implementation specific, because the reader is already sitting next to the code that implements them:

- helper/method names and signatures
- keyword-argument patterns
- file paths and cross-file references
- RFC or spec section numbers
- byte-level or step-by-step mechanics

Those details are valuable in commit messages and PR descriptions, not in an inline comment. If the principle still reads cleanly without them, they were noise.

## 3. Describe the current state, never the journey

A comment describes the current design and its invariants, not how the design was reached. Scan for narrative tells and rewrite if any appear:

> earlier, previously, used to, originally, was changed, we tried, the old version, was refactored from

If a historical detail is genuinely load-bearing (a maintainer might reintroduce a broken pattern), rephrase it as a forward-looking property of the current design:

- Bad: _"An earlier version dispatched the rebuild from `appendTransaction`, but that broke sync on paste."_
- Good: _"The rebuild lives outside `appendTransaction` because doing it there interferes with document sync on paste."_

Same warning, framed as a fact about the present code. Litmus test: would this make sense to someone who joined yesterday and has no idea the code ever looked different?

## 4. Don't explain framework conventions

Don't comment on well-known framework behavior (validator lookup, ORM scopes, lifecycle callbacks, routing conventions). A reader fluent in the framework doesn't need it, and it rots when the framework changes.

Ask: "would a framework-fluent reader need this to understand the code?" If they could derive it from the code plus knowledge of how the framework works, skip it. Comments earn their place by explaining domain-specific WHYs, not framework idioms.

## 5. Plain words, not reviewer-jargon

Prefer plain English over shorthand a senior reviewer might use in a synchronous discussion. In persistent text these read as filler. Specifically avoid:

- **"load-bearing"** - say what breaks if removed: "this guards X", "removing this makes the cache miss in the Y case".
- **"symmetrical" / "asymmetrical"** - state what is actually the same or different.
- **"pre-PR behaviour" / "matching the legacy shape"** - references history. Describe the current invariant directly.
- **"already in this codebase"** - hand-wavy. If you mean a sibling pattern, name it.
- **"the invariant is replicated here" / "pre-invariant"** - CS-lecture register. Say what is true: "the row is created here to match."

If a phrase like "load-bearing" feels right, force yourself to spell out why. One extra clause usually covers it.

---

## Revision-pass checklist

After drafting, scan the comment for each of these. If any appears, rewrite:

- Does it need to exist at all, or would deleting it lose nothing?
- Helper/method name, kwarg pattern, file path, or RFC/spec citation
- "earlier" / "previously" / "used to" / "originally" / "we tried"
- Restates a framework convention a fluent reader already knows
- "load-bearing" / "symmetrical" / "pre-PR" / "legacy" / "already in this codebase"
- Would a developer who joined yesterday understand it without reading another file or knowing project history?

If the code needs history or cross-file knowledge to follow, the comment isn't doing its job - fix the code's readability or move the rationale to the test name, commit message, or PR description.
