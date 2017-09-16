ilver

Silver implements a SQL-like language to interact with an OVSDB instance.

In OVSDB, the communication protocol is implemented in JSON-RPC 1.0. Silver will communicate with the database instance by parsing the user input into RPC methods.

## Silver language description

### Database operations

+ <atom>
+ <set>
A square brace enclosed list of `atom` values. Example: ["bike", "car", "bus"], []
+ <map>
A curly brace enclosed list of `<pair>` that represent a database map object. Example: {}, {"color":"blue", "wheels":4}
+ <value>
Represents the value of a column in a table row, one of `<atom>`, `<set>`, or `<map>`.
+ <table>
An `<id>` that names a table.
+ <columns>
A comma separated list of `<id>` of column names. Example: `id, name, description, location`.
+ <values>
A comma separated list of one or more `<value>`. Example: `1, "chair", {"color":"blue", "price":250}, [1, 2, 3, 5]`

#### Insert
```
INSERT INTO <table> (<columns>) VALUES (<values>);
```

```
INSERT INTO <table> (<column>+) VALUES (<value>+) NAMED <id>;
```

#### Select
```
SELECT * FROM <table>;
```
```
SELECT <column>+ FROM <table> WHERE <condition>+;
```

#### Update
```
UPDATE <table> SET <assignment>+;
```
```
UPDATE <table> SET <assignment>+ WHERE <condition>+;
```

#### Mutate
```
MUTATE <table> APPLY <assignment>+;
```
```
MUTATE <table> APPLY <assignment>+ WHERE <condition>+;
```

#### Delete
```
DELETE <table>;
```
```
DELETE <table> <assignment>+ WHERE <condition>+;
```

