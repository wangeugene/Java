## UI Entry point

https://cloud.elastic.co/home

## Change to manage to your cluster

```shell
ES_HOST="https://eugene-es-cluster.es.us-east-2.aws.elastic-cloud.com"
ES_API_KEY="UEs3ZmE0d0J3ZFVSQzlxUjlmQXE6cWRGSERMbTFUTE9OaWxaaVdpTzNSQQ=="
```

Succeeded uploading
API KEY: the BreadCrumb UI: Stack Management -> API Keys


> upload reqs file

```shell
curl -XPOST -i -k -H "Content-Type: application/x-ndjson" -H "Authorization: ApiKey $ES_API_KEY" $ES_HOST/_bulk --data-binary "@reqs"; echo
```

> upload account.json

```shell
curl -XPOST -i -k -H "Content-Type: application/x-ndjson" -H "Authorization: ApiKey $ES_API_KEY" $ES_HOST/bank/_bulk --data-binary "@accounts.json"; echo
```

?pretty option didn't work, but removing that worked.

```shell
curl -XPOST -i -k -H "Content-Type: application/x-ndjson"  -H "Authorization: ApiKey $ES_API_KEY"  $ES_HOST/shakespeare/_bulk --data-binary @shakespeare.json; echo
```
`curl: (92) HTTP/2 stream 1 was not closed cleanly: INTERNAL_ERROR (err 2)`