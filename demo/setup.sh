#!/usr/bin/env bash
# Build and start the two demo hosts, and write the ssh key and config that
# reach them as web-01 and analytics-warehouse. Nothing outside demo/.state
# is changed, ~/.ssh/config in particular.
set -euo pipefail

demo=$(cd "$(dirname "$0")" && pwd)
state=$demo/.state
mkdir -p "$state"

if [ ! -f "$state/demo_key" ]; then
    ssh-keygen -q -t ed25519 -N '' -C tmux-scp-demo -f "$state/demo_key"
fi

cat > "$state/ssh_config" <<EOF
# written by setup.sh, used through demo/bin/ssh
Host web-01
    HostName 127.0.0.1
    Port 2221
    User deploy

Host analytics-warehouse
    HostName 127.0.0.1
    Port 2222
    User data_pipeline

Host *
    IdentityFile $state/demo_key
    IdentitiesOnly yes
    UserKnownHostsFile $state/known_hosts
    StrictHostKeyChecking accept-new
    LogLevel ERROR
EOF

AUTHORIZED_KEY=$(cat "$state/demo_key.pub") docker compose -f "$demo/compose.yaml" up -d --build --force-recreate

# the containers get new host keys when recreated
rm -f "$state/known_hosts"
for host in web-01 analytics-warehouse; do
    for _ in $(seq 30); do
        if "$demo/bin/ssh" -o BatchMode=yes -o ConnectTimeout=2 "$host" true 2>/dev/null; then
            echo "$host is up"
            continue 2
        fi
        sleep 1
    done
    echo "$host did not come up, see: docker compose -f $demo/compose.yaml logs" >&2
    exit 1
done
echo "ready, now run $demo/start.sh"
