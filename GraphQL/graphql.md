### Query Language

url: http://localhost:3000/graphql

[GraphQL Types Introduction](https://graphql.com/learn/introducing-types/)

There are two main categories of types in GraphQL: object types and scalar types

- object types: define what structure of responses we expect graphQL service returns

```graphql
type Fruit {
    name: String
    quantity: Int
    price: Int
    averageWeight: Float
    hasEdibleSeeds: Boolean
}
```

- scalar types: similar to primitive types in other programming languages, e.g. String/Int/Float/Boolean
- query types: root types/entry point types/lives in schema definitions
- list types: return a collection of object instance, definition syntax: [ ], the following nutrients are of list types

```graphql
type Fruit {
    id: ID
    name: String
    quantity: Int
    price: Int
    averageWeight: Float
    hasEdibleSeeds: Boolean
    nutrients: [String]
}
```