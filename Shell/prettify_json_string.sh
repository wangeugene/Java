response='{
  "encodedJwt": "example-JWT",
  "name": "eugene"
}'
if [[ $response != *"encodedJwt"* ]]; then
  echo "Response does not contain encodedJwt field"
  exit 1
else
  echo "Response contains encodedJwt field"
  echo $response | jq .
fi