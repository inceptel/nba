# autoweb — self-improving NBA Dashboard

> **This is a live demo of [autoweb](https://github.com/inceptel/autoweb)** — an autonomous UI improvement agent.
> Every change in this repo was made by an AI agent running in a loop. No human edited the dashboard after the initial scaffold.
> The agent screenshots the page, picks one improvement, verifies it, and either keeps or reverts — forever.

## The target

- **File to edit**: `/home/user/public/nba/index.html`
- **URL to screenshot**: `https://allan.feather-cloud.dev/public/nba/`
- **Repo**: `https://github.com/inceptel/nba`
- **Data source**: ESPN unofficial API (no auth needed)

## What you CAN do

- Edit `/home/user/public/nba/index.html` (single file, vanilla JS + CSS)
- Add CDN libraries via script/link tags
- Improve data display, layout, UX, visual polish
- Add new features: standings, player stats, game details, injury reports
- Add new ESPN API endpoints — see `https://site.api.espn.com/apis/site/v2/sports/basketball/nba/`

## What you CANNOT do

- Break the ESPN API fetch or auto-refresh loop
- Make the page fail to load or show a blank screen
- Remove score display — that is the core feature
- Require a backend or server-side code (static HTML only)

## How to verify

```bash
agent-browser --url "https://allan.feather-cloud.dev/public/nba/" --task "Screenshot this page. Describe what you see. Does the NBA dashboard show games with scores? Any visual bugs or layout issues?"
```

## How to log results

```bash
# Keep:
printf "%s\tkeep\tDESCRIPTION\n" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> /home/user/autoweb-nba/results.tsv

# Revert:
cp /home/user/public/nba/index.html.bak /home/user/public/nba/index.html
printf "%s\trevert\tDESCRIPTION\n" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> /home/user/autoweb-nba/results.tsv
```

## Run tests before keeping

```bash
cd /home/user/public/nba && bash tests/run-tests.sh
# All tests must pass before logging a keep
```

## The experiment loop

LOOP FOREVER:

1. **Screenshot** the live URL with agent-browser. Read `index.html`. Check `results.tsv` for recent attempts.

   **CURRENT FOCUS: general** — Fix bugs first, then UX improvements, then visual polish. Make every iteration count.

2. **Check deadline**: `echo $(($(cat /home/user/autoweb-nba/deadline) - $(date +%s)))s left`

3. **Pick ONE improvement**. Priority order:
   - Bugs / broken things (CRITICAL/HIGH below)
   - UX problems (confusing, missing info)
   - Visual polish (spacing, colors, typography)
   - New features (standings tab, player search, etc.)

4. **Backup**: `cp /home/user/public/nba/index.html /home/user/public/nba/index.html.bak`

5. **Make the change**. Keep it focused — one thing only.

6. **Run tests**: `cd /home/user/public/nba && bash tests/run-tests.sh`
   If tests fail → revert immediately.

7. **Verify visually** with agent-browser screenshot.

8. **Log and exit**. The harness handles git commit + push automatically.

## Known issues (priority order)

- HIGH: No loading state shown while API fetches — user sees blank content briefly
- HIGH: Scheduled games show tip-off time in away score column — layout is wrong
- MEDIUM: No standings tab — would be very useful alongside scores
- MEDIUM: Team logos are text initials — try fetching ESPN team logo URLs
- MEDIUM: Player leader stats missing from many games — check API response structure
- LOW: No dark/light mode toggle
- LOW: Mobile: game cards could be more compact
- LOW: Add yesterday/tomorrow navigation arrows

## Design principles

- **Data-dense**: show as much useful info as possible without clutter
- **Dark first**: dark background (#0a0a0f) is the baseline — never break it
- **Monospace**: JetBrains Mono / Fira Code for that Bloomberg terminal feel
- **Team colors**: use team primary colors for accents wherever possible
- **Live games first**: always sorted live → final → scheduled
- **Auto-refresh**: 20s when live games, 60s otherwise — never break this

## autoweb features showcased here

This repo demonstrates the full autoweb feature set:

- **Screenshot verification** — every change verified with a real browser screenshot
- **Test suite** — bash tests run before every keep (red/green)
- **Auto-push** — every kept change commits and pushes to this GitHub repo
- **Review loop** — runs every 4h, updates this program.md with learnings
- **results.tsv** — full audit log of every iteration
- **Breadcrumbs** — agent leaves notes between iterations

## Rules learned from experience

- Always verify with agent-browser — do not trust the code alone
- One change per iteration — resist the urge to fix multiple things
- If the page goes blank, revert immediately before logging
- ESPN API returns `competitors[0]` as either home or away — always check `homeAway` field
