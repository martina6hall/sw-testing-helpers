#!/bin/bash

# Copyright 2016 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

set -e

# NOTES:
#     To delete a tag use: git push origin :v1.0.0

if [[ $1 != "patch" && $1 != "minor" && $1 != "major" ]] ; then
  echo "    Bad input: Expected an update type of \"patch\", \"minor\" or \"major\"";
  exit 1;
fi

echo ""
echo "Sign into npm"
echo ""
npm whoami &>/dev/null || npm login

echo ""
echo ""
echo "Update NPM Version"
echo ""
# We don't want to create a git tag against master branch. We want to tag
# against the new directory 'tagged-release', but we do want package.json
# in master to have the new version
PACKAGE_VERSION=$(npm --no-git-tag-version version $1)

echo ""
echo ""
echo "Are you sure you want to publish a new version of Propel [$PACKAGE_VERSION] y/N?"
echo ""
read answer
if [[ $answer != "y" && $answer != "Y" ]]; then
  # Revert the change to package.json
  git checkout package.json
  echo "    Not publishing the new release.";
  exit 1;
fi

echo ""
echo ""
echo "Create and Copy Files for Release"
echo ""
# Remove any remaining artifacts from previous builds
rm -rf ./tagged-release
mkdir tagged-release

# Copy over files that we want in the release
cp -r ./helpers ./tagged-release
cp -r ./test ./tagged-release
cp LICENSE ./tagged-release
cp package.json ./tagged-release
cp README.md ./tagged-release

cd ./tagged-release/

echo ""
echo ""
echo "Git push to release branch"
echo ""
GIT_REPO="https://github.com/GoogleChrome/sw-testing-helpers.git"
git init
git remote add origin $GIT_REPO
git checkout -b release
git add .
git commit -m "New tagged release - $PACKAGE_VERSION"
git tag -f $PACKAGE_VERSION
git push -f origin release $PACKAGE_VERSION

echo ""
echo ""
echo "Publish update to NPM"
echo ""
npm publish

echo ""
echo ""
echo "Removing Tagged Release"
echo ""
cd ..
rm -rf ./tagged-release

echo ""
echo ""
echo "Generating a PR to update masters package.json"
echo ""

git add package.json
git commit -m "Auto-generated PR to update package.json with new version - $PACKAGE_VERSION"
git push -f origin release-pr

./node_modules/pullr/bin/pullr.js --new --from release-pr --into master --title 'Auto-generated PR to update the version number' --description 'Please review this change and ensure that package.json is the ONLY file changed AND that the version matches the latest tagged release.'