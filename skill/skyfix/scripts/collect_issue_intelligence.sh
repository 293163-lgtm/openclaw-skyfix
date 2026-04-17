#!/usr/bin/env bash
set -euo pipefail

QUERY="${*:-openclaw gateway telegram issue}"
DOCS_URL="https://docs.openclaw.ai"
GITHUB_REPO="https://github.com/openclaw/openclaw"
ENCODED_QUERY="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' "$QUERY")"

cat <<EOF
== skyfix issue intelligence starter ==
query: $QUERY

docs:
- ${DOCS_URL}
- ${DOCS_URL}/troubleshooting
- ${DOCS_URL}/faq

github:
- ${GITHUB_REPO}
- ${GITHUB_REPO}/issues
- https://github.com/search?q=${ENCODED_QUERY}+repo%3Aopenclaw%2Fopenclaw&type=issues

community/search hints:
- Search OpenClaw Discord/community for: "$QUERY"
- Search docs + troubleshooting before treating it as a novel bug.

local operator steps:
1. Reproduce the symptom and capture the exact error/log line.
2. Compare against docs/troubleshooting first.
3. Check GitHub issue search URL above for matching symptoms.
4. Return with 1-3 ranked hypotheses, not raw link spam.
EOF
