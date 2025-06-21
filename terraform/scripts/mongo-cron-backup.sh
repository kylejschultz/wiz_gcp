#!/bin/bash
set -e

# Fetch project ID from metadata
PROJECT_ID="clgcporg10-155"

TIMESTAMP=$(date +%Y-%m-%d_%H%M)
DUMP_DIR="/tmp/mongodump-${TIMESTAMP}"
ARCHIVE="/tmp/mongodump-${TIMESTAMP}.tar.gz"

# Create dump
mongodump --host 127.0.0.1 \
          --username "kyle" \
          --password "gcpDemo" \
          --authenticationDatabase "admin" \
          --out "${DUMP_DIR}"

# Archive and upload
tar czf "${ARCHIVE}" -C "/tmp" "mongodump-${TIMESTAMP}"
gsutil cp "${ARCHIVE}" "gs://wiz-db-backups-${PROJECT_ID}/mongodump-${TIMESTAMP}.tar.gz"

# Cleanup
rm -rf "${DUMP_DIR}" "${ARCHIVE}"
