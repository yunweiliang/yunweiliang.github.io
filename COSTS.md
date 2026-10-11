# Build costs

Cumulative cost of building the Bouncer, recorded at each milestone.

Figures are the usage that Claude sessions report about themselves, priced
at API rates. They are estimates, not a bill: on a Claude subscription you
pay the plan price, not these amounts. Work before 2026-10-11 (the redesign,
PRs #6 to #10) was done in sessions that weren't tracked here.

| Date (UTC) | Milestone | Tokens this step | Cost this step | Cumulative cost |
| --- | --- | --- | --- | --- |
| 2026-10-11 00:39 | Planning, Stage 0 gate, plan doc, project notes | 8.0M (7.9M cached reads, 23K output) | $3.02 | $3.02 |

How it's counted: the sum of `usage.cost_usd` across the project's Claude
sessions (the coordinator and each thread). Most tokens are cached context
re-read on every step, which is billed at a fraction of normal input.
