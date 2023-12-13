# History

In 1999 Lucene came out, then evolved into Elasticsearch in 2010

# Definition

A distributed search engine that can be used to index resources to make searching related items more easily

# Characteristics

It uses JSON and HTTP to do the interaction
Use Cases: Security/log analytics; Marketing; Operations (Monitoring a server); Search;
Cluster -> Node -> Index -> Type -> Document -> Shard/Replica

# Free trial

[Elasticsearch](https://www.elastic.co)

## Console Command

~~~http request
## Overall Cluster Health
GET /_cat/health?v

## Node Health
GET /_cat/nodes?v

## List Indices
GET /_cat/indices?v

## Create 'sales' Index
PUT /sales

## Add 'order' to 'sales' index
PUT /sales/_doc/123
{
    "orderID": "123",
    "orderAmount": "500
}

## Retrieve document
GET /sales/_doc/123

## Delete document
DELETE /sales

~~~

# To work with ES with curl command

1.get the ES http endpoint, get the API key
the reqs json

~~~json
[
  {
    "index": {
      "_index": "my-test",
      "_id": "1"
    }
  },
  {
    "col1": "val1"
  },
  {
    "index": {
      "_index": "my-test",
      "_id": "1"
    }
  },
  {
    "col1": "val2"
  }
]
~~~

upload some data into the ES cluster with not formatted JSON request body

~~~ shell
ES_HOST="http_endpoint_ulr"
echo $ES_HOST
ES_API_KEY="api_key"
echo ES_API_KEY
curl -XPOST -i -k -H "Content-Type: application/x-ndjson" -H "Authorization: ApiKey $ES_API_KEY" $ES_HOST/_bulk --data-binary "@reqs"; echo
~~~

upload prettified json file to ES cluster, no need to upload the schema of json first

~~~shell
curl -XPOST -i -k -H "Content-Type: application/x-ndjson" -H "Authorization: ApiKey $ES_API_KEY" $ES_HOST/bank/_bulk?pretty --data-binary "@accounts.json"; echo
~~~

`Note: the bank is the index of accounts.json`

~~~http request
GET /_cat/indices

GET /bank

GET /bank/_doc/1 // 1 is the index id in accounts.json file 

GET /_cat/indices/logstash-*

GET logstash-2015.05.18/_count

PUT /shakespeare
{
"json" : "a schema to despict the json structure that used to create specific docs" 
}

GET bank/_search
// request body; search criterions json: bank_search*.json
~~~

# Additional data types

Complex / Geo / Specialized

#  