FROM ubuntu:20.04

# Install MongoDB client, gsutil & dependencies
RUN apt-get update && \
    apt-get install -y gnupg curl ca-certificates apt-transport-https \
                       mongodb-org-tools google-cloud-sdk && \
    rm -rf /var/lib/apt/lists/*

# Copy our backup script
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

ENTRYPOINT ["/usr/local/bin/backup.sh"]
