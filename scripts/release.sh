#!/usr/bin/env bash
set -eu +x

# this apps deployment variables
export APP_VERSION=`cat "build.version" | perl -pe 's/^.*(\d+\.\d+\.\d+).*$/\1/'`
exit_code=0
$(git describe --exact-match --tags HEAD 2>/dev/null | grep release-${APP_VERSION}) || exit_code=$?
if [ $exit_code -eq 0 ] ; then
     echo "Skipping release as current HEAD is same as release tag: release-${APP_VERSION}"
     exit 0
else
    git config --global user.email "team-github-action@eedevsecops.com"
    git config --global user.name "By GITHUB ACTION"

    COMPLETE_VERSION="$APP_VERSION"
    remainder="$COMPLETE_VERSION"
    MAJOR="${remainder%%.*}"; remainder="${remainder#*.}"
    MINOR="${remainder%%.*}"; remainder="${remainder#*.}"
    PATCH="${remainder%%.*}"; remainder="${remainder#*.}"

    NEW_PATCH=$((PATCH+1))
    NEW_APP_VERSION=$(echo "$MAJOR.$MINOR.$NEW_PATCH")

    echo "Current version: $APP_VERSION"
    echo "New version: $NEW_APP_VERSION"

    echo " branch name ----------------- $1"

    echo "Building git tag for branch"
    echo "version=$NEW_APP_VERSION" > build.version
    echo "Creating and pushing release version: release-$NEW_APP_VERSION"
    git commit -am "[Release Commit] - new version commit: 'release-$NEW_APP_VERSION'." && git push origin $1
    echo "Creating tag: release-$NEW_APP_VERSION"
    git tag -a release-$NEW_APP_VERSION -m "[Release Commit] - new version commit: 'release-$NEW_APP_VERSION'."
    echo "Pushing tag to remote: release-$NEW_APP_VERSION"
    git push origin release-$NEW_APP_VERSION
    echo "Release tag created and pushed: release-$NEW_APP_VERSION"
    export LATEST_TAG=$NEW_APP_VERSION

fi