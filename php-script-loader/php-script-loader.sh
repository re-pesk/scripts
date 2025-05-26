#!/usr/bin/env bash
php -r "
$(tail -n +2 ${1##*/})" # New line is necessary here for proper line numbering
