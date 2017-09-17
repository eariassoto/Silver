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

%type <listTok>  columns
%type <listTok>  valueslist
%type <listTok>  atoms
%type <listTok>  keyvalues
%type <valueTok> atom
%type <valueTok> value
%type <valueTok> insert
%type <valueTok> keyvalue
%type <valueTok> composed
%type <strTok>   stringAtom
%type <boolTok>  boolAtom

%%

program : program operation SEMICOLON
        | operation SEMICOLON
	{ fmt.Println("Got a valid SQL operation") }

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
		fmt.Printf("%s\n", $$.Print())
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
		fmt.Printf("%s\n", $$.Print())
	}
};

// select
select : base_select
       | base_select where

base_select : SELECT STAR FROM ID
            | SELECT columns FROM ID

// update
update : UPDATE ID SET assignments
       | UPDATE ID SET assignments where

// mutate
mutate : MUTATE ID APPLY mutations
       | MUTATE ID APPLY mutations where

// delete
delete : DELETE ID
       | DELETE ID where


assignments : assignment COMMA assignments
            | assignment

assignment : ID EQUALS value

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

where : WHERE conditions

conditions : condition COMMA conditions
           | condition

condition : ID function value

function : LE
         | LT
         | GE
         | GT
         | EQ
         | NE
	     | INCLUDES
	     | EXCLUDES

mutations : mutation COMMA mutations
          | mutation

mutation : ID mutator value

mutator : INCR
        | DECR
		| MULT
		| DIV
		| MOD
		| MUT_INS
		| MUT_DEL

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
	l.PushFront(&$1)
	$$ = l
};

keyvalues : keyvalue
{
	l := list.New()
	l.PushBack(&$1)
	$$ = l
};

keyvalue : atom COLON atom
{
	$$ = &sql2ovs.KeyValue{&$1, &$3}
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
