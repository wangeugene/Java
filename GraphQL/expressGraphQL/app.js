const express = require('express')
const {graphqlHTTP} = require('express-graphql');
const {buildSchema} = require('graphql')


const schema = buildSchema(`
    type Account{
        name: String,
        age: Int,
        sex: String,
        department: String
    },
    type Query {
        foo: String
        account: Account
    }
`)

const root = {
    account: () => {
        return {
            name: "Eugene",
            age: 32,
            sex: "Male",
            department: "IT"
        }
    },
    foo() {
        return 'bar'
    }
}

const app = express();

app.use('/graphql', graphqlHTTP({
    schema: schema,
    rootValue: root,
    graphiql: true
}))

app.listen(8080);