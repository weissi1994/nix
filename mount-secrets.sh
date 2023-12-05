#/bin/sh

mkdir -p /run/secrets

gopass list -f | while read -r SECRET; do
	printf 'Mounting secret: /run/secrets/%s\n' "$SECRET"
	gopass fscopy "$SECRET" "/run/secrets/$SECRET"
done
