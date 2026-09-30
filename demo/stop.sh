#!/usr/bin/env bash
# Stop the demo tmux server and remove the demo containers. The ssh key in
# demo/.state is kept for next time; delete that directory to start over.
set -euo pipefail

demo=$(cd "$(dirname "$0")" && pwd)
env -u TMUX tmux -L tmux-scp-demo kill-server 2>/dev/null || true
AUTHORIZED_KEY=unused docker compose -f "$demo/compose.yaml" down
