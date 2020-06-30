#!/bin/bash

set -e

cat ../settings/dconf/plank.dconf | dconf load /net/launchpad/plank/docks/dock1
