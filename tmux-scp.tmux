#!/usr/bin/env bash
# tmux plugin entry point: binds the keys and : commands to the tmux-scp
# script next to this file. Load it with TPM or `run-shell` (see README.md).

bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/tmux-scp"

option() {
    local value
    value=$(tmux show-option -gqv "$1")
    echo "${value:-$2}"
}

yank_key=$(option @tmux-scp-yank-key C-y)
put_key=$(option @tmux-scp-put-key C-p)
alias_index=$(option @tmux-scp-alias-index 100)
popup="display-popup -E -w 80% -h 50% -T ' tmux-scp '"

tmux bind-key "$yank_key" run-shell -b "'$bin' --client '#{client_name}' yank '#{pane_id}'"
tmux bind-key "$put_key" run-shell -b "'$bin' --client '#{client_name}' put '#{pane_id}'"

i=$alias_index
for cmd in scp yank put; do
    tmux set-option -s "command-alias[$i]" "$cmd=$popup '$bin' $cmd"
    i=$((i + 1))
done
