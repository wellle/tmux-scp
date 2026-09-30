#!/bin/sh
# Put this host's demo files in place, removing whatever an earlier take
# copied there. start.sh runs it over ssh as the demo user before each take.
set -eu
. /etc/demo.env

dir=$HOME/$DEMO_DIR
mkdir -p "$dir"
rm -rf "${dir:?}"/*
cd "$dir"

case $DEMO_FILES in
web)
    awk 'BEGIN {
        print "order_id,customer_id,amount_eur,created_at"
        for (i = 1; i <= 110000; i++)
            printf "%d,%d,%.2f,2026-09-%02d\n", 100000 + i, (i * 7919) % 5000, (i * 37 % 10000) / 100, i % 30 + 1
    }' > orders-2026-09.csv
    awk 'BEGIN {
        print "refund_id,order_id,amount_eur"
        for (i = 1; i <= 3100; i++)
            printf "%d,%d,%.2f\n", 900000 + i, 100000 + (i * 13) % 110000, (i * 53 % 5000) / 100
    }' > refunds-2026-09.csv
    printf 'export finished, 110000 orders, 3100 refunds\n' > export.log
    touch -d '2026-09-29 23:58' refunds-2026-09.csv
    touch -d '2026-09-30 00:04' orders-2026-09.csv
    touch -d '2026-09-30 00:05' export.log
    ;;
warehouse)
    awk 'BEGIN {
        print "customer_id,country,segment"
        for (i = 1; i <= 5000; i++)
            printf "%d,%s,%s\n", i, substr("DEUSFRGBNLES", (i % 6) * 2 + 1, 2), (i % 3 ? "retail" : "business")
    }' > customers.csv
    printf 'loaded customers.csv, 5000 rows\n' > load.log
    touch -d '2026-09-28 06:00' customers.csv
    touch -d '2026-09-28 06:01' load.log
    ;;
esac
