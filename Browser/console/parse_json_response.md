copy (to copy content to clipboard)

```edge console
copy(
    JSON.parse(document.body.textContent)
    .filter(e => e.id != null & e.status == 'Pending')
    .map(e => { return { 'id': e.id, 'status': e.status} })
    )
```

