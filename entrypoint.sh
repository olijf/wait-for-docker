#!/bin/sh
set -e

# Prepend "./wait-for.sh" if the first argument is not an executable
if ! type -- "$1" &> /dev/null; then
	set -- ./wait-for.sh "$@"
fi

exec "$@"
