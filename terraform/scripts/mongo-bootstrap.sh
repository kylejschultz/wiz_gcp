#!/bin/bash

if command -v mongod &> /dev/null
then
    echo "MongoDB is already installed. Exiting startup script."
    exit 0
fi

echo "MongoDB not found. Proceeding with installation."
set -e

sudo apt-get update
sudo apt-get install -y gnupg curl

curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt-get update
sudo apt-get install -y mongodb-org=6.0.24 mongodb-org-database=6.0.24 mongodb-org-server=6.0.24 mongodb-mongosh mongodb-org-shell=6.0.24 mongodb-org-mongos=6.0.24 mongodb-org-tools=6.0.24 mongodb-org-database-tools-extra=6.0.24

sudo systemctl enable mongod
sudo systemctl start mongod

echo "MongoDB installation complete."

echo "Enable password auth"
sudo tee -a /etc/mongod.conf <<'EOF'

security:
  authorization: "enabled"
EOF

echo "Allow Mongo to listen on all interfaces"
sudo sed -i 's/^[[:space:]]*bindIp:.*$/  bindIp: 0.0.0.0/' /etc/mongod.conf

sudo systemctl restart mongod

until mongosh --host localhost --authenticationDatabase admin --eval 'db.runCommand({ ping: 1 })' > /dev/null 2>&1; do
  echo "Waiting for MongoDB to start..."
  sleep 2
done

echo "Bootstrapping admin user"
mongosh admin --eval 'db.createUser({
  user: "kyle",
  pwd: "gcpDemo",
  roles: [ { role: "root", db: "admin" } ]
})'

echo "Setting up Mongo Backup Cron Job"
MARKER="/var/lib/mongo-cron-backup.initialized"
if [ ! -f "$MARKER" ]; then
  apt-get update && apt-get install -y cron curl
  systemctl enable cron
  systemctl start cron
  curl -fsSL https://raw.githubusercontent.com/kylejschultz/wiz_gcp/refs/heads/main/terraform/scripts/mongo-cron-backup.sh \
    -o /usr/local/bin/mongo-cron-backup.sh
  chmod +x /usr/local/bin/mongo-cron-backup.sh
  echo '0 */8 * * * root /usr/local/bin/mongo-cron-backup.sh >> /var/log/mongo-cron.log 2>&1' \
    > /etc/cron.d/mongo-cron-backup
  touch "$MARKER"
fi
