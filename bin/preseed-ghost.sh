#!/usr/bin/env bash
set -e

# Ghost bundles its own Koenig/Lexical component packages as nested
# "file:components/*.tgz" dependencies inside its own npm package. npm tries
# to resolve those before it has finished extracting the "ghost" package
# itself to disk, which fails with ENOENT on a clean install (and on Heroku,
# every build is a clean install). Pre-extracting the tarball into
# node_modules/ghost before `npm install` runs works around this.

GHOST_RANGE=$(node -e "process.stdout.write(require('./package.json').dependencies.ghost)")

if [ -d "node_modules/ghost" ]; then
	exit 0
fi

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

npm pack "ghost@${GHOST_RANGE}" --pack-destination "$TMPDIR" --silent

mkdir -p node_modules/ghost
tar -xzf "$TMPDIR"/ghost-*.tgz -C node_modules/ghost --strip-components=1
