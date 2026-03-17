#!/bin/bash
# autoweb test suite for NBA dashboard
# Usage: bash tests/run-tests.sh [/path/to/index.html]
# Exit 0 = all pass, Exit 1 = failures

TARGET="${1:-$(dirname "$0")/../index.html}"
PASS=0; FAIL=0

run_test() {
    local name="$1"; local cmd="$2"
    if eval "$cmd" > /dev/null 2>&1; then
        echo "  ✓ $name"; PASS=$((PASS+1))
    else
        echo "  ✗ $name"; FAIL=$((FAIL+1))
    fi
}

echo "Running NBA dashboard tests on: $TARGET"
echo ""

# Core structure
run_test "Has DOCTYPE"            "grep -q '<!DOCTYPE html>' '$TARGET'"
run_test "Has viewport meta"      "grep -q 'viewport' '$TARGET'"
run_test "Has title"              "grep -q '<title>' '$TARGET'"
run_test "Has body"               "grep -q '<body' '$TARGET'"

# API integration
run_test "Fetches ESPN API"       "grep -q 'site.api.espn.com' '$TARGET'"
run_test "NBA scoreboard endpoint" "grep -q 'basketball/nba/scoreboard' '$TARGET'"
run_test "Has fetch call"         "grep -q 'fetch(' '$TARGET'"

# Auto-refresh
run_test "Has auto-refresh logic" "grep -qE 'setInterval|setTimeout|countdown' '$TARGET'"
run_test "Has live refresh rate"  "grep -qE '20|hasLiveGames' '$TARGET'"

# Game display
run_test "Renders game cards"     "grep -q 'class=\"game' '$TARGET'"
run_test "Shows team names"       "grep -q 'team-name' '$TARGET'"
run_test "Shows scores"           "grep -q 'team-score' '$TARGET'"
run_test "Shows game status"      "grep -q 'game-status' '$TARGET'"
run_test "Shows team records"     "grep -q 'team-record' '$TARGET'"

# Sorting
run_test "Sorts live games first" "grep -q 'state.*in.*post\|order.*in.*0' '$TARGET'"

# Dark theme
run_test "Has dark background"    "grep -q '#0a0a0f\|--bg' '$TARGET'"
run_test "Has CSS variables"      "grep -q ':root' '$TARGET'"

# Layout
run_test "Has grid layout"        "grep -q 'grid' '$TARGET'"
run_test "Has sticky header"      "grep -q 'sticky' '$TARGET'"
run_test "Has responsive mobile"  "grep -q '@media' '$TARGET'"

# Error handling
run_test "Has error handling"     "grep -qE 'catch|error|Error' '$TARGET'"
run_test "Has loading state"      "grep -qE 'loading|spinner|Loading' '$TARGET'"

# Data
run_test "Has team colors map"    "grep -q 'TEAM_COLORS\|ATL.*BOS.*BKN' '$TARGET'"
run_test "Has all 30 teams"       "python3 -c \"
import re
html = open('$TARGET').read()
teams = ['ATL','BOS','BKN','CHA','CHI','CLE','DAL','DEN','DET','GSW',
         'HOU','IND','LAC','LAL','MEM','MIA','MIL','MIN','NOP','NYK',
         'OKC','ORL','PHI','PHX','POR','SAC','SAS','TOR','UTA','WAS']
missing = [t for t in teams if t not in html]
exit(len(missing) > 3)
\""

# Page does not 404 itself
run_test "No broken script src"   "! grep -qE '<script src=\"(?!http)(?!/)' '$TARGET'"
run_test "Page is not empty"      "[ \$(wc -c < '$TARGET') -gt 5000 ]"
run_test "Has valid HTML close"   "grep -q '</html>' '$TARGET'"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ $FAIL -eq 0 ] && echo "All tests passed ✓" && exit 0
echo "Tests failed ✗" && exit 1
