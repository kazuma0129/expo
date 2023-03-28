#!/usr/bin/env bash

set -xeuo pipefail

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../../.. && pwd )"
export PATH="$ROOT_DIR/bin:$PATH"


notify_slack(){
  curl \
    -X POST \
    -H 'Content-type: application/json' \
    --data "{ \"text\": \"$1\", \"attachments\": [ { \"text\": \"$2\", \"color\": \"danger\" } ] }" \
    $SLACK_HOOK
}

fake_notify_slack(){
  echo "TITLE: $1"
  echo "MESSAGE: $2"
}

SLUG="unversioned-expo-go"
if [[ "$EAS_BUILD_PROFILE" == "versioned-client" ]]; then
  SLUG="versioned-expo-go"
elif [[ "$EAS_BUILD_PROFILE" == "versioned-client-add-sdk" ]]; then
  SLUG="versioned-expo-go-add-sdk"
fi

COMMIT_HASH="$(git rev-parse HEAD)"
COMMIT_AUTHOR="$(git log --pretty=format:"%an - %ae" | head -n 1)"

EAS_BUILD_MESSAGE_PART="EAS Build: [$EAS_BUILD_ID](https://expo.dev/accounts/expo-ci/projects/$SLUG/builds/$EAS_BUILD_ID)"
GITHUB_MESSAGE_PART="GitHub: [$COMMIT_HASH](https://github.com/expo/expo/commit/$COMMIT_HASH)"

TITLE="Successfull $EAS_BUILD_PLATFORM build - $EAS_BUILD_PROFILE"
MESSAGE="Author: $COMMIT_AUTHOR\\n$EAS_BUILD_MESSAGE_PART\\n$GITHUB_MESSAGE_PART"

fake_notify_slack $TITLE $MESSAGE
