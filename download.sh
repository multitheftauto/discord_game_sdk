#!/usr/bin/env bash

# Fail on error
set -e

# Ensure repo is not dirty
if [[ $(git diff --stat) != '' ]]; then
    echo 'Repository is dirty. Aborting.'
    exit 1
fi

NOW=$(date +"%Y-%d-%m_%H-%M-%S")

# Move sdk folder if it exists
if [ -e sdk ]; then
    mv sdk "sdk-pre-$NOW"
fi

# Download sdk
rm -f discord_game_sdk.zip
wget https://dl-game-sdk.discordapp.net/latest/discord_game_sdk.zip

# Unzip to sdk folder
unzip discord_game_sdk.zip -d sdk
rm discord_game_sdk.zip

# Add sdk folder to git
git add sdk

# Abort if the sdk folder has not changed
if [[ $(git diff --cached --stat sdk) == '' ]]; then
    echo 'SDK is unchanged. Aborting.'
    exit 1
fi

# Commit and push
git commit -m "Update SDK"
git tag "v$NOW"
git push origin master "v$NOW"
