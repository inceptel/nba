# autoweb — self-improving NBA Dashboard

> **This is a live demo of [autoweb](https://github.com/inceptel/autoweb)** — an autonomous UI improvement agent.
> Every change in this repo was made by an AI agent running in a loop. No human edited the dashboard after the initial scaffold.
> The agent screenshots the page, picks one improvement, verifies it, and either keeps or reverts — forever.

## The target

- **File to edit**: `/home/user/public/nba/index.html`
- **URL to screenshot**: `https://allan.feather-cloud.dev/public/nba/`
- **Repo**: `https://github.com/inceptel/nba`
- **Data source**: ESPN unofficial API (no auth needed)
- **Autoweb dashboard**: `https://allan.feather-cloud.dev/public/nba/autoweb-dashboard.html`

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

   **CURRENT FOCUS: box scores — 6 REVIEWS DEFERRED, IMPLEMENT NOW OR REVERT AND TRY AGAIN** — All known bugs are fixed. Leaders and Standings tabs are fully complete with no remaining polish. **ANY change other than box score MUST be reverted.** Do not add colors, badges, columns, or any other polish — there is nothing left to polish. The ONLY acceptable next change is: add a box score / team stats section to final and live game cards (FG%, rebounds, turnovers, assists) using the ESPN gamecast API (`summary?event={gameId}`). **Simplest UI**: use a native `<details><summary>▼ Box Score</summary>…</details>` element — no JS toggle needed, browser handles expand/collapse natively. Lazy-fetch on first expand by listening for the `toggle` event on the `<details>` element. **If you are not implementing box score, you are doing the wrong task — revert and start over with box score.** After box score: injury reports, head-to-head records.

2. **Check deadline**: `echo $(($(cat /home/user/autoweb-nba/deadline 2>/dev/null || echo 9999999999) - $(date +%s)))s left`
   - If the deadline file is missing, continue normally (no hard stop).

3. **Pick ONE improvement**. Priority order:
   - Bugs / broken things (CRITICAL/HIGH below)
   - UX problems (confusing, missing info)
   - Visual polish (spacing, colors, typography)
   - New features (standings tab, player search, etc.)

4. **Backup**: `cp /home/user/public/nba/index.html /home/user/public/nba/index.html.bak`

5. **Make the change**. Keep it focused — one thing only.

6. **Run tests**: `cd /home/user/public/nba && bash tests/run-tests.sh`
   If tests fail → revert immediately.
   If `tests/run-tests.sh` does not exist, skip this step and note it in your log.

7. **Verify visually** with agent-browser screenshot.

8. **Log and exit**. The harness handles git commit + push automatically.

## Known issues (priority order)

Mark fixed issues with ~~strikethrough~~ rather than deleting them.

- ~~HIGH: Scheduled games show tip-off time in away score column — layout is wrong (check `homeAway` field for scheduled game rendering, not just live/final)~~ (fixed iter 1)
- ~~HIGH: No loading state shown while API fetches — user sees blank content briefly~~ (initial load had spinner; date nav now also shows spinner)
- ~~LOW: `usingYesterday` variable undefined in empty-state message (shows "today" instead of "recently" when auto-fallback to yesterday occurred)~~ (fixed iter 5)
- ~~MEDIUM: No standings tab — would be very useful alongside scores~~ (fixed iter 7 — full standings with W/L/PCT/GB/L10/HOME/ROAD/CONF/DIFF/STRK)
- ~~MEDIUM: Team logos are text initials — try fetching ESPN team logo URLs~~
- ~~MEDIUM: Player leader stats missing from many games — check API response structure~~ (fixed iter 23 — shows 2 leaders per team)
- ~~LOW: No dark/light mode toggle~~
- ~~LOW: Mobile: game cards could be more compact~~ (fixed iter 30)
- ~~LOW: Add yesterday/tomorrow navigation arrows~~ (fixed iter 3)

### Potential next features (no known bugs remain)

- ~~Leaders tab polish: headshots, medal ranks, team logos, relative stat bars~~ (fully done)
- ~~Standings table columns: W/L/PCT/GB/HOME/ROAD/CONF/DIFF/L10/STRK, sortable, sticky team column~~ (fully done — no new columns needed)
- **MEDIUM (TOP PRIORITY — 6+ REVIEWS DEFERRED, DO THIS NOW — NOT NEXT, NOW): Box score / team stats for final/live games** — FG%, rebounds, turnovers, assists per team; use ESPN gamecast/summary API: `https://site.api.espn.com/apis/site/v2/sports/basketball/nba/summary?event={gameId}` (gameId = `event.id` from scoreboard). Key fields: `boxscore.teams[].statistics[]` for team totals (FG%, rebounds, turnovers, assists). IMPLEMENTATION: use `<details><summary>▼ Box Score</summary></details>` native HTML — listen for the `toggle` event to lazy-fetch on first open; cache result on `details.dataset` so re-opens don't re-fetch. Do NOT fetch at page load (10+ parallel requests will be slow). **This is the only task. Do not pick anything else.**
- MEDIUM: Injury report — show key player injuries on game cards (ESPN injury API exists)
- LOW: Head-to-head season record shown on game cards
- LOW: Team schedule popup — click team logo/name to see upcoming games
- LOW: Playoff bracket tab — visual bracket for postseason (when applicable)
- LOW: Player search — search any player for season stats

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
- The footer autoweb dashboard link must point to `https://allan.feather-cloud.dev/public/nba/autoweb-dashboard.html` — verify this is correct on every iteration and fix it if it's wrong
- One change per iteration — resist the urge to fix multiple things
- If the page goes blank, revert immediately before logging
- ESPN API returns `competitors[0]` as either home or away — always check `homeAway` field
- The `homeAway` field bug affects scheduled games differently than live/final — test all three states
- Mark fixed issues with ~~strikethrough~~ in Known Issues — do not delete them
- **ESPN API reliability**: `site.api.espn.com` endpoints can go 404 without warning — always verify a new API endpoint returns 200 with valid data before building on it
- **Leaders API**: `site.api.espn.com/apis/site/v2/sports/basketball/nba/leaders` is 404 (broken). Use `sports.core.api.espn.com/v2/sports/basketball/leagues/nba/seasons/{year}/types/2/leaders` instead. Note: this API uses `$ref` links for athletes; batch-fetch athlete names with `Promise.all`.
- **Regression risk**: the dashboard now has 15+ features — when verifying a new iteration, check that the Standings tab, Leaders tab, and date navigation still work, not just the feature you changed
- **Leaders tab complexity**: Leaders tab uses a hardcoded ESPN team ID → abbreviation map and batch-fetches `$ref` athlete links. If adding features to Leaders tab, validate that all 8 stat categories still render correctly after your change. **Do not touch Leaders tab** — it is fully complete and the batch-fetch logic is fragile.
- **Box score API**: `https://site.api.espn.com/apis/site/v2/sports/basketball/nba/summary?event={gameId}` — returns full game summary. `boxscore.teams[].statistics[]` has team totals (FG%, REB, TOV, AST, etc.). `boxscore.players[].statistics[]` has individual player lines. Fetch on-demand (not at page load) to avoid 10+ simultaneous requests.
- **Box score UI pattern**: Use native `<details><summary>▼ Box Score</summary></details>` HTML — listen for `toggle` event to lazy-fetch on first expand. Store fetched data in `details.dataset.fetched = '1'` to prevent re-fetching. This is simpler than a JS toggle and requires no extra state management.
- **Polish moratorium**: Standings and Leaders tabs are fully complete. Do not add more polish features until box score is implemented. This has been the rule for 5+ reviews — enforce it.
- **Box score is critically overdue**: It has been deferred for 6 consecutive review cycles — more than any other feature in this project's history. The API is known, the UI pattern is known, the lazy-fetch approach is known. There are zero blockers. If you pick any other task, revert it and implement box score instead. There is no acceptable alternative.
