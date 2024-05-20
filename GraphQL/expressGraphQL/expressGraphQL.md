Start the app locally:

`npm start`

Kill the process using port 8080:

```zsh
sh ../../zsh/killProcessesByPorts.sh
```

---

http://localhost:8080/graphql

---

- A very basic query, to get a String value

```graphql
{
    foo
}
```

---

- A full query with operation type `query` and operation name `named operation`

```graphql
query namedOperation{
    account {
        name
        age
        department
        sex
    }
}
```

- A shortcut version graphql query, the same as above

```graphql
{
    account {
        name
        age
        department
        sex
    }
}
``` 

---