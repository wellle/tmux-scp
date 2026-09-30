#!/usr/bin/env bash
# Start the demo: a separate tmux server with web-01 in the top pane and
# analytics-warehouse in the bottom one, both showing their files, and the
# cursor in the top pane. Run it in the terminal window you record.
#
#   start.sh             start and attach
#   start.sh --detached  start only, for scripting
set -euo pipefail

demo=$(cd "$(dirname "$0")" && pwd)
if [ ! -f "$demo/.state/ssh_config" ]; then
    echo "run $demo/setup.sh first" >&2
    exit 1
fi

# read by tmux.conf, and a yank of its own so the demo leaves yours alone
export TMUX_SCP_REPO
TMUX_SCP_REPO=$(dirname "$demo")
export TMUX_SCP_STATE=$demo/.state/yank.json
rm -f "$TMUX_SCP_STATE"

# the same files on both hosts for every take
for host in web-01 analytics-warehouse; do
    "$demo/bin/ssh" -o BatchMode=yes "$host" demo-seed
done

t() { env -u TMUX tmux -L tmux-scp-demo -f "$demo/tmux.conf" "$@"; }
t kill-server 2>/dev/null || true
# the size of this terminal, so the panes are laid out for it before attaching
cols=$(tput cols 2>/dev/null || true)
lines=$(tput lines 2>/dev/null || true)
t new-session -d -s demo -x "${cols:-120}" -y "${lines:-35}"
t split-window -v -t demo

# log in, then show a clean screen with the files in each pane
t send-keys -t demo:1.1 "$demo/bin/ssh web-01" Enter
t send-keys -t demo:1.2 "$demo/bin/ssh analytics-warehouse" Enter
for pane in 1 2; do
    for _ in $(seq 50); do
        t capture-pane -p -t "demo:1.$pane" | grep -q '\$ *$' && break
        sleep 0.2
    done
    t send-keys -t "demo:1.$pane" 'clear; ls -lhtr' Enter
done
t select-pane -t demo:1.1

if [ "${1:-}" != --detached ]; then
    t attach -t demo
fi
