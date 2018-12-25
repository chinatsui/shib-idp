#!/bin/sh
docker-compose up --build -d

echo ""
echo "If everything above was successful, your IdP metadata can be retreived with this command (after a minute or two):"
echo "                    curl -k https://127.0.0.1/idp/shibboleth"
echo ""

