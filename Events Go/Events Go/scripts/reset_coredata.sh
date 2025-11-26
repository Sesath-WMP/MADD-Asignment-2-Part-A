#!/usr/bin/env bash
set -euo pipefail

# Reset Core Data persistent store for Simulator builds
# Usage: run while the simulator app is not running.

APP_BUNDLE_ID="com.example.LocalEventFinder"

echo "Resetting Core Data store for $APP_BUNDLE_ID on iOS Simulator..."
xcrun simctl get_app_container booted "$APP_BUNDLE_ID" data >/dev/null 2>&1 || {
  echo "App not installed on the current simulator. Nothing to reset."
  exit 0
}

CONTAINER_PATH=$(xcrun simctl get_app_container booted "$APP_BUNDLE_ID" data)
echo "Container: $CONTAINER_PATH"

# Remove Application Support and Library/Caches related to Core Data
rm -rf "$CONTAINER_PATH/Library/Application Support" || true
rm -rf "$CONTAINER_PATH/Library/Caches" || true

echo "Done. Relaunch the app to re-seed from Resources/SeedEvents.json."
