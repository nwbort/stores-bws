#!/bin/bash
set -e

TEMP_DIR=$(mktemp -d)
STATES=("VIC" "ACT" "QLD" "TAS" "WA" "NSW" "SA" "NT")

# Download each state
for state in "${STATES[@]}"; do
  echo "Downloading ${state}..."
  curl -s "https://api.bws.com.au/apis/ui/StoreLocator/Stores/bws?state=${state}&type=allstores&Max=999999" \
    -o "${TEMP_DIR}/${state}.json"
done

# Merge all Stores arrays and sort by StoreNo (as number)
jq -s '{ Stores: [.[].Stores[]] | sort_by(.StoreNo | tonumber) }' "${TEMP_DIR}"/*.json > stores.json

# Clean up
rm -rf "$TEMP_DIR"

echo "Created stores.json with $(jq '.Stores | length' stores.json) stores"
