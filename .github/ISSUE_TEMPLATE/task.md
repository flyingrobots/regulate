---
name: Task
about: One outcome, delivered by one pull request
---

```yaml
.dag: issue-dag/2
.id: flyingrobots/regulate#NUMBER
.kind: task
.type: feature
.blocked_by: []
.size_hours: 2
```

<!--
After you create the issue, edit it and replace NUMBER with the issue's own
number. Until then the dependency graph will not compile.

.type is one of: feature, bug, decision, research, investigation, spike, task.
Every reference is written owner/repo#number.
Delete these comments before saving.
-->

## Outcome

<!-- One sentence, one subject, one verb. If it needs "and", it is two tasks. -->

## Scope

<!-- What the pull request contains. -->

## Out of scope

<!-- What a reader might expect that this leaves out, and where that work lives. -->

## Prerequisites

<!-- Each .blocked_by entry and the reason it must close first. "None." if there are none. -->

## Safe intermediate state

<!-- What main is like after this merges and before its dependents do. -->

## Acceptance

- [ ] <!-- An exact, observable result. -->
