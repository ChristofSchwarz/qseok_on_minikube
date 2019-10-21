TKN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Im15LWtleS1pZGVudGlmaWVyIn0.eyJpc3MiOiJodHRwczovL3FsaWsuYXBpLmludGVybmFsIiwiYXVkIjoicWxpay5$
HOST=https://192.168.56.234

TENANT=$(curl --insecure -s \
  -X GET "$HOST/api/v1/users" \
  -H "Authorization: Bearer $TKN" \
| jq '.data[0].tenantId' -r)

echo "You are tenant $TENANT"

curl --insecure -s \
  -X PUT "$HOST/api/v1/tenants/$TENANT/licenseDefinition" \
  -H "Authorization: Bearer $TKN" \
  -H "Content-Type: application/json" \
  -d '{"key":"eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6ImEzMzdhZDE3LTk1ODctNGNhOS05M2I3LTBiMmI5ZTNlOWI0OCJ9.eyJqdGkiOiJmYTZhMTc3ZS01MGRi$
echo ""

curl --insecure \
  -X GET "$HOST/api/v1/licenses/overview" \
  -H "Authorization: Bearer $TKN" \
  -H "Content-Type: application/json"
echo ""
