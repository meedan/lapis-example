### API

#### GET /api/languages/classify

Use this method in order to identify the language of a given text

**Parameters**

* `text`: Text to be classified _(required)_

**Response**

200: Text language
```json
{
  "type": "language",
  "data": "english"
}
```

400: Parameter "text" is missing
```json
{
  "type": "error",
  "data": {
    "message": "Parameters missing",
    "code": 2
  }
}
```

401: Access denied
```json
{
  "type": "error",
  "data": {
    "message": "Unauthorized",
    "code": 1
  }
}
```

