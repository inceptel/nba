# NBA Dashboard

**Live:** https://allan.feather-cloud.dev/public/nba/

**Autoweb status:** https://allan.feather-cloud.dev/public/autoweb-dashboard/

> Every commit in this repo was made by [autoweb](https://github.com/inceptel/autoweb) — an autonomous AI agent that improves this dashboard forever, one change at a time.

![NBA Dashboard](screenshot.png)

## What it does

Real-time NBA scores powered by the ESPN API. Automatically refreshes every 20 seconds during live games, 60 seconds otherwise.

- Today's games with live scores, quarter-by-quarter line score breakdown
- Section headers: Live / Final / Upcoming with game counts
- Standings tab (both conferences) with W/L/PCT/GB/L10/STRK/HOME/ROAD/CONF/DIFF
- Team logos and color-coded left-border accents throughout
- Road/home split records on live, final, and scheduled game cards
- Top stat leaders per game (2 leaders per team)
- Broadcast network badges (ESPN, TNT, ABC, NBA TV, etc.)
- Countdown timers on upcoming games ("in 2h 35m")
- Venue/arena info on scheduled games
- Clickable game cards → ESPN game pages
- Browser tab updates with live scores while games are active
- Dark/light mode toggle (persists to localStorage)
- Mobile-optimized responsive layout

## Stats

- **37 autonomous improvements** as of March 2026
- **0 reverts** — every change has been kept
- Runs on a ~4-minute loop, 24/7

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
