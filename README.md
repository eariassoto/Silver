# Silver

Silver implements a SQL-like language to interact with an OVSDB instance.

In OVSDB, the communication protocol is implemented in JSON-RPC 1.0. Silver will communicate with the database instance by parsing the user input into RPC methods.

## Silver language description
The terminology for the language description is based on the [RFC 7047](https://tools.ietf.org/html/rfc7047) format. Some components are described as in the JSON RPC protocol. Other components have been modified to suit Silver syntax.
## Basic components
+ `<string>`

A quoted string.  Any Unicode string is allowed. Example: `"red"`

+ `<number>`

Numbers must be an integer or a floating point. Example: `42, 81.9`

+ `<boolean>`

Either `true` or `false`

+ `<uuid>`

A 36-character string giving the UUID in the format described by RFC 4122 [RFC4122](https://tools.ietf.org/html/rfc4122). Example: `550e8400-e29b-41d4-a716-446655440000`

+ `<named-uuid>`

An `<id>` to name the uuid of a "insert" operation within the same transaction. 

+ `<atom>`

A value that represents a scalar value for a column, one of `<string>`, `<number>`, `<boolean>`, `<uuid>`, or `<named-uuid>`.
+ `<function>`

One of `"<"`, `"<="`, `"=="`, `"!="`, `">="`, `">"`, `"includes"`, or `"excludes"`.

+ `<set>`

A square brace enclosed list of `atom` values. Example: `["bike", "car", "bus"], []`

+ `<map>`

A curly brace enclosed list of `<pair>` that represent a database map object. Example: `{}, {"color":"blue", "wheels":4}`

+ `<value>`

Represents the value of a column in a table row, one of `<atom>`, `<set>`, or `<map>`.

+ `<table>`

An `<id>` that names a table.

+ `<column>`

An `<id>` that names a column.

+ `<columns>`

A comma separated list of `<column>`. Example: `id, name, description, location`.

+ `<values>`

A comma separated list of one or more `<value>`. Example: `1, "chair", {"color":"blue", "price":250}, [1, 2, 3, 5]`

+ `<assignments>`

A comma separated list representing changes for columns. An assigment has this format: `<column> = <value>`. Example: `"color"="red", "price":500, "discount": true`

+ `<conditions>`

A comma separated list of conditions to be evaluated. A condition has this format: `<column> <function> <value>`. Example: `"color" "==" "blue", "price" "<" 300`

## Database operations
### 1. Insert
```
INSERT INTO <table> (<columns>) VALUES (<values>);
```

```
INSERT INTO <table> (<columns>) VALUES (<values>) NAMED <id>;
```

### 2. Select
```
SELECT * FROM <table>;
```
```
SELECT <columns> FROM <table> WHERE <condition>;
```

### 3. Update
```
UPDATE <table> SET <assignment>;
```
```
UPDATE <table> SET <assignment> WHERE <condition>;
```

### 4. Mutate
```
MUTATE <table> APPLY <assignments>;
```
```
MUTATE <table> APPLY <assignments> WHERE <conditions>;
```

### 5. Delete
```
DELETE <table>;
```
```
DELETE <table> <assignments> WHERE <conditions>;
```
