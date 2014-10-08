#!/bin/bash
# run this using:
# $ . $HOME/.dotfiles/apply.sh
#
# apply.sh (c) 2014 Ian Weller, distributed under the following license
# without any warranty:
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

relpath() {
    perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV) . "\n"' "$1" "$2"
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd $DOTFILES_DIR
git remote update -p
git merge --ff-only @{u}
git submodule init
git submodule update
popd

base="$DOTFILES_DIR/home"
find "$base" '(' -type f -o -type l ')' -print0 | while read -r -d '' file; do
    link="$HOME/$(relpath $file $base)"
    if [ "$(dirname $link)" != "$HOME" ]; then
        mkdir -p "$(dirname $link)"
    fi
    ln -sfvn "$file" "$link"
done
