/**
* MIT License
*
* Copyright (c) 2017 Emmanuel Arias Soto
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

%{
package parser

import (
	"container/list"
    "fmt"
	"math/big"
	"github.com/eariassoto/Silver/sql2ovs"
)

func Parse(lex *lexer) {
	yyParse(lex)
}
%}

%union {
   strTok   *string
   numTok   *big.Rat
   boolTok  bool
   listTok  *list.List
   valueTok sql2ovs.Printable
}

%token
LPAREN
RPAREN
STAR
COMMA
LCURLY
RCURLY
LBRACE
RBRACE
EQUALS
LE
LT
GE
GT
EQ
NE
COLON
SEMICOLON
INCR
DECR
MULT
DIV
MOD

INSERT
INTO
VALUES
NAMED
SELECT
FROM
UPDATE
SET
MUTATE
APPLY
DELETE
WHERE
AND
OR
INCLUDES
EXCLUDES
MUT_INS
MUT_DEL

STRING
ID
NUMBER
UUID
TRUE
FALSE

%token <strTok>  STRING
%token <strTok>  ID
%token <numTok>  NUMBER
%token <strTok>  UUID
%token <boolTok> TRUE
%token <boolTok> FALSE
%token <strTok>  INCR
%token <strTok>  DECR
%token <strTok>  MULT
%token <strTok>  DIV
%token <strTok>  MOD
%token <strTok>  MUT_INS
%token <strTok>  MUT_DEL
%token <strTok>  LE
%token <strTok>  LT
%token <strTok>  GE
%token <strTok>  GT
%token <strTok>  EQ
%token <strTok>  NE
%token <strTok>  INCLUDES
%token <strTok>  EXCLUDES

%type <listTok>  mutations
%type <listTok>  assignments
%type <listTok>  conditions
%type <listTok>  columns
%type <listTok>  valueslist
%type <listTok>  atoms
%type <listTok>  keyvalues
%type <valueTok> function
%type <valueTok> assignment
%type <valueTok> condition
%type <valueTok> mutation
%type <valueTok> atom
%type <valueTok> value
%type <valueTok> select
%type <valueTok> update
%type <valueTok> delete
%type <valueTok> mutate
%type <valueTok> insert
%type <valueTok> mutator
%type <valueTok> keyvalue
%type <valueTok> composed
%type <strTok>   stringAtom
%type <boolTok>  boolAtom

%%

program : program operation SEMICOLON
        | operation SEMICOLON

operation : insert
          | select
          | update
		  | mutate
          | delete

// insert
insert :
    INSERT INTO ID LPAREN columns RPAREN VALUES LPAREN valueslist RPAREN
{
	// TODO errors should be handled up to the last reduction
	insert, err := sql2ovs.NewInsert($3, $5, $9)
	if err != nil {
		fmt.Printf("Error: %s", err.Error())
	} else {
		$$ = insert
		fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
	}
};

insert :
    INSERT INTO ID LPAREN columns RPAREN VALUES LPAREN valueslist RPAREN NAMED ID
{
	insert, err := sql2ovs.NewNamedInsert($3, $5, $9, $12)
	if err != nil {
		fmt.Printf("Error: %s", err.Error())
	} else {
		$$ = insert
		fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
	}
};

// select
select : SELECT columns FROM ID
{
	sel := &sql2ovs.Select{$4, $2, nil}
	$$ = sel
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

select : SELECT columns FROM ID WHERE conditions
{
	sel := &sql2ovs.Select{$4, $2, $6}
	$$ = sel
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

select : SELECT STAR FROM ID
{
	sel := &sql2ovs.Select{$4, nil, nil}
	$$ = sel
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

select : SELECT STAR FROM ID WHERE conditions
{
	sel := &sql2ovs.Select{$4, nil, $6}
	$$ = sel
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

// update
update : UPDATE ID SET assignments
{
	upd := &sql2ovs.Update{$2, $4, nil}
	$$ = upd
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

update : UPDATE ID SET assignments WHERE conditions
{
	upd := &sql2ovs.Update{$2, $4, $6}
	$$ = upd
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

// mutate
mutate : MUTATE ID APPLY mutations
{
	mut := &sql2ovs.Mutate{$2, $4, nil}
	$$ = mut
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

mutate : MUTATE ID APPLY mutations WHERE conditions
{
	mut := &sql2ovs.Mutate{$2, $4, $6}
	$$ = mut
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

// delete
delete : DELETE ID
{
	del := &sql2ovs.Delete{$2, nil}
	$$ = del
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

delete : DELETE ID WHERE conditions
{
	del := &sql2ovs.Delete{$2, $4}
	$$ = del
	fmt.Printf("ovsdb-client transact '[\"OpenSwitch\", %s]'\n", $$.Print())
};

assignments : assignment COMMA assignments
{
	l := $3
	l.PushFront($1)
	$$ = l
};

assignments : assignment
{
	l := list.New()
	l.PushBack($1)
	$$ = l
};

assignment : ID EQUALS value
{
	$$ = &sql2ovs.Assignment{$1, $3}
};

columns : ID COMMA columns
{
	l := $3
	l.PushFront(&sql2ovs.StringValue{$1})
	$$ = l
};

columns : ID
{
	l := list.New()
	l.PushBack(&sql2ovs.StringValue{$1})
	$$ = l
};

conditions : condition COMMA conditions
{
	l := $3
	l.PushFront($1)
	$$ = l
};

conditions : condition
{
	l := list.New()
	l.PushBack($1)
	$$ = l
};

condition : ID function value
{
	$$ = &sql2ovs.Condition{$1, $2, $3}
};

function : LE { $$ = &sql2ovs.StringValue{$1} };
function : LT { $$ = &sql2ovs.StringValue{$1} };
function : GE { $$ = &sql2ovs.StringValue{$1} };
function : GT { $$ = &sql2ovs.StringValue{$1} };
function : EQ { $$ = &sql2ovs.StringValue{$1} };
function : NE { $$ = &sql2ovs.StringValue{$1} };
function : INCLUDES { $$ = &sql2ovs.StringValue{$1} };
function : EXCLUDES { $$ = &sql2ovs.StringValue{$1} };

mutations : mutation COMMA mutations
{
	l := $3
	l.PushFront($1)
	$$ = l
};

mutations : mutation
{
	l := list.New()
	l.PushBack($1)
	$$ = l
};

mutation : ID mutator value
{
	$$ = &sql2ovs.Mutation{$1, $2, $3}
};

mutator : INCR { $$ = &sql2ovs.StringValue{$1} };
mutator : DECR { $$ = &sql2ovs.StringValue{$1} };
mutator : MULT { $$ = &sql2ovs.StringValue{$1} };
mutator : DIV { $$ = &sql2ovs.StringValue{$1} };
mutator : MOD { $$ = &sql2ovs.StringValue{$1} };
mutator : MUT_INS { $$ = &sql2ovs.StringValue{$1} };
mutator : MUT_DEL { $$ = &sql2ovs.StringValue{$1} };

atoms : atom COMMA atoms
{
	l := $3
	l.PushFront($1)
	$$ = l
};

atoms : atom
{
	l := list.New()
	l.PushBack($1)
	$$ = l
};

valueslist : value COMMA valueslist
{
	l := $3
	l.PushFront($1)
	$$ = l
};

valueslist : value
{
	l := list.New()
	l.PushBack($1)
	$$ = l
};

value : atom
      | composed
{
	$$ = $1
};

composed : LCURLY RCURLY
{
	$$ = sql2ovs.NewEmptyMap()
};

composed : LCURLY keyvalues RCURLY
{
	$$ = &sql2ovs.Map{$2}
};

composed : LBRACE RBRACE
{
	$$ = sql2ovs.NewEmptySet()
};

composed : LBRACE atoms RBRACE
{
	$$ = &sql2ovs.Set{$2}
};

keyvalues : keyvalue COMMA keyvalues
{
	l := $3
	l.PushFront($1)
	$$ = l
};

keyvalues : keyvalue
{
	l := list.New()
	l.PushBack($1)
	$$ = l
};

keyvalue : atom COLON atom
{
	$$ = &sql2ovs.KeyValue{$1, $3}
};

stringAtom : STRING
           | ID
		   | UUID

atom : stringAtom
{
	$$ = &sql2ovs.StringValue{$1}
};

atom : NUMBER
{
	$$ = &sql2ovs.NumericValue{$1}
};

boolAtom : TRUE
         | FALSE

atom : boolAtom
{
	$$ = &sql2ovs.BoolValue{$1}
};
