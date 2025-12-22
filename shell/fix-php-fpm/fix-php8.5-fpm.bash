
#!/usr/bin/env bash

echo "Fixing php8.5-fpm.service"

sudo sed -i.backup '/[Service]/{n; s/Type=notify/Type=exec/}' "/lib/systemd/system/php8.5-fpm.service"
