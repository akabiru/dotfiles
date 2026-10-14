---
name: copilot-triage
description: Triage the latest GitHub Copilot review on a pull request - list its open findings, classify each as fix, already fixed or rejected, and after the fixes are committed reply on every thread with the commit sha or the reason. Use when the user pastes a Copilot review link, says "copilot left a review", "triage copilot", "answer the copilot threads", or invokes /copilot-triage <pr>.
---

# copilot-triage

Copilot reviews arrive as one review with inline threads plus a body that may list "previously missed" items with no thread. Triage all of it, fix what deserves fixing, answer every thread once, and leave the PR description alone.

## 1. Fetch

```bash
gh api repos/opf/openproject/pulls/<n>/reviews --jq '[.[] | select(.user.login == "copilot-pull-request-reviewer[bot]")] | last | {id, commit_id, state, body}'
gh api "repos/opf/openproject/pulls/<n>/comments?per_page=100" --jq '[.[] | select(.pull_request_review_id == <review id>) | {id, path, line: (.line // .original_line), body, in_reply_to_id}]'
```

If the user gave a review URL (`#pullrequestreview-<id>`), use that id instead of `last`. Items under "Previously missed" live only in the review body; parse the `path:line` there. Threads that already have a reply from the user or from this session are done; skip them.

Compare the review's `commit_id` with the branch head. A finding on code that changed after the review may already be fixed; say so with the sha instead of fixing twice.

## 2. Classify, then show the table before touching code

One line per finding: severity Copilot gave, file:line, verdict, one-sentence reason.

- **fix**: a real bug, a security gap, a failing or wrong spec, a missed edge case. Default for anything the user would accept from a human reviewer.
- **already fixed**: the head no longer has the problem. Name the sha.
- **reject**: wrong about the code (check by reading the code, or by running the spec Copilot claims fails), or a style preference the project does not share. Say exactly what Copilot got wrong; "disagree" alone is not a verdict.

Stop here and wait for the user's go on the fix list, unless they already said "take it".

## 3. Fix

One commit per finding or per tightly related group, normal commit message rules (no WP-ID prefix, body says why). Run the affected specs serialised on `backend-test`; vitest in the frontend container. Do not push until the user's standing instruction for this branch allows it.

## 4. Reply on every thread, after the push

```bash
gh api -X POST repos/opf/openproject/pulls/<n>/comments/<thread id>/replies -f body="<text>"
```

Text register: one or two sentences, sha first for fixes ("Fixed in <sha>: ..."), the concrete reason for rejections ("Not changed: the spec passes because Capybara's rack_test driver honours data-turbo-method; verified by running it."). No AI attribution, no "great catch", no em dashes.

Items without a thread (the "previously missed" list) cannot be answered inline; report them to the user with the verdict and let them decide whether to comment on the PR.

Never resolve threads, never edit the PR description, never submit a review of your own; those belong to the user.

## 5. Report

Table of findings with verdict and sha or reason, plus anything left for the user (threadless items, rejected findings they may want to argue themselves).
