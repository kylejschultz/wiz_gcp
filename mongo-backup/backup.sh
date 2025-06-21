#!/bin/sh
set -e

TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
DUMP_DIR="/tmp/mongodump-$TIMESTAMP"
ARCHIVE="/tmp/mongodump-$TIMESTAMP.tar.gz"

# 1) Dump the database (all DBs, authenticated)
mongodump --host "$MONGO_HOST" \
          --username "$MONGO_USER" \
          --password "$MONGO_PASS" \
          --authenticationDatabase "admin" \
          --out "$DUMP_DIR"

# 2) Archive it
tar czf "$ARCHIVE" -C "/tmp" "mongodump-$TIMESTAMP"

# 3) Upload to GCS
gsutil cp "$ARCHIVE" "gs://${BUCKET}/mongodump-$TIMESTAMP.tar.gz"

echo "Backup complete: gs://${BUCKET}/mongodump-$TIMESTAMP.tar.gz"
