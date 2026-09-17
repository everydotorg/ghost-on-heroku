#!/usr/bin/env bash
set -e

# Ghost bundles its own Koenig/Lexical component packages as nested
# "file:components/*.tgz" dependencies inside its own npm package. npm tries
# to resolve those before it has finished extracting the "ghost" package
# itself to disk, which fails with ENOENT on a clean install (and on Heroku,
# every build is a clean install). Pre-extracting the tarball into
# node_modules/ghost before `npm install` runs works around this.

GHOST_RANGE=$(node -e "process.stdout.write(require('./package.json').dependencies.ghost)")

# Heroku's build cache can restore node_modules from a PREVIOUS deploy's
# ghost version (e.g. after a version bump). Only skip preseeding if the
# already-present node_modules/ghost is actually the version we need -
# otherwise it's stale and must be removed and re-extracted, or npm will
# try to install against mismatched/missing component tarballs.
if [ -d "node_modules/ghost" ]; then
	INSTALLED_VERSION=$(node -e "try { process.stdout.write(require('./node_modules/ghost/package.json').version) } catch (e) {}")
	if [ "$INSTALLED_VERSION" = "$GHOST_RANGE" ]; then
		exit 0
	fi
	rm -rf node_modules/ghost
fi

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

npm pack "ghost@${GHOST_RANGE}" --pack-destination "$TMPDIR" --silent

mkdir -p node_modules/ghost
tar -xzf "$TMPDIR"/ghost-*.tgz -C node_modules/ghost --strip-components=1
