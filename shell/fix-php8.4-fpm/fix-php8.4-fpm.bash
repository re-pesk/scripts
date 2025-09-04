
#!/usr/bin/env bash

echo "Fixing php8.4-fpm.service"

sed -i.backup '/[Service]/{n; s/Type=notify/Type=exec/}' "$1"
