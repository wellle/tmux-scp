#!/bin/sh
# Set up the demo user and its prompt, then run sshd. The files come from
# demo-seed, which start.sh runs before each take.
# Environment: DEMO_USER, DEMO_DIR (relative to its home), DEMO_FILES
# (web or warehouse) and AUTHORIZED_KEY.
set -eu

home=/home/$DEMO_USER
if ! id "$DEMO_USER" >/dev/null 2>&1; then
    adduser -D -s /bin/bash "$DEMO_USER"
    # no password, but not locked either, so sshd lets keys in
    echo "$DEMO_USER:*" | chpasswd -e
fi

printf 'DEMO_DIR=%s\nDEMO_FILES=%s\n' "$DEMO_DIR" "$DEMO_FILES" > /etc/demo.env

mkdir -p "$home/.ssh" "$home/$DEMO_DIR"
printf '%s\n' "$AUTHORIZED_KEY" > "$home/.ssh/authorized_keys"
chmod 700 "$home/.ssh"
chmod 600 "$home/.ssh/authorized_keys"

# green user@host, blue directory, like a typical server prompt
cat > "$home/.bashrc" <<'EOF'
PS1='\[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\] $ '
alias ls='ls --color=auto'
EOF
cat > "$home/.bash_profile" <<EOF
. ~/.bashrc
cd ~/$DEMO_DIR
EOF
chown -R "$DEMO_USER:$DEMO_USER" "$home"

ssh-keygen -A >/dev/null
exec /usr/sbin/sshd -D -e
