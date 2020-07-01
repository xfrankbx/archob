#!/bin/bash

set -e

mkdir -p ~/.config/plank/dock1/launchers

cp ../settings/.config/plank/dock1/launchers/* ~/.config/plank/dock1/launchers/

cat ../settings/dconf/plank.dconf | dconf load /net/launchpad/plank/docks/dock1/
