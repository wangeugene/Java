# put the content of this file into ~/script.sh, then it will work
# don't run directly in IDE, because special path will cause error, e.g.  = not found
response="{\"encodedJwt\":\"example_value\"}"
encodedJwt=$(echo $response | jq -r .encodedJwt)
echo "$encodedJwt"
# assert value equals expected value
expected_encodedJwt="example_value"
if [ "$encodedJwt" == "$expected_encodedJwt" ];
then
  echo "Test passed"
else
  echo "Test failed"
fi