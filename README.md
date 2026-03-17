# NBA Dashboard

**Live:** https://allan.feather-cloud.dev/public/nba/

> Every commit in this repo was made by [autoweb](https://github.com/inceptel/autoweb) — an autonomous AI agent that improves this dashboard forever, one change at a time.

![NBA Dashboard](screenshot.png)

## What it does

Real-time NBA scores powered by the ESPN API. Automatically refreshes every 20 seconds during live games, 60 seconds otherwise.

- Today's games with live scores, quarter-by-quarter breakdown
- Team records, game status (live clock, final, tip-off time)
- Top performers (points, rebounds, assists leaders)
- All 30 teams with team colors
- Sorted: live → final → scheduled

## How it self-improves

An autoweb agent runs in a loop 24/7:

1. Screenshots the live dashboard
2. Picks one improvement (bug fix, UX, visual polish, new feature)
3. Makes the change, runs the test suite
4. Verifies with another screenshot
5. Keeps or reverts based on the result
6. Commits and pushes here automatically

Every commit message starts with `autoweb:` — browse the [commit history](../../commits/main) to see the full log of autonomous improvements.

## Test suite

```bash
bash tests/run-tests.sh
```

27 tests covering API integration, game display, auto-refresh, dark theme, layout, and error handling. All changes must pass before being kept.

## Running your own autoweb

```bash
git clone https://github.com/inceptel/autoweb
cp autoweb/program.md.example myproject/program.md
# edit program.md: set your target URL and file
./autoweb/run.sh
```

See [inceptel/autoweb](https://github.com/inceptel/autoweb) for full docs.

---

Built by [Inceptel](https://inceptel.com) · Powered by [autoweb](https://github.com/inceptel/autoweb)
