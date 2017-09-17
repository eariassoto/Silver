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
	"math/big"
    "fmt"
)

func Parse(lex *lexer) {
	yyParse(lex)
}
%}

%union {
   strTok  *string
   numTok  *big.Rat
   boolTok bool
}

%token <strTok> STRING
%token <strTok> ID
%token <numTok> NUMBER
%token <strTok> UUID
%token <boolTok> TRUE
%token <boolTok> FALSE

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
insert : base_insert
       | base_insert named

base_insert :
    INSERT INTO ID LPAREN columns RPAREN VALUES LPAREN valueslist RPAREN

named : NAMED ID

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
        | ID

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

valueslist : value COMMA valueslist
       | value

value : atom
      | composed

// TODO add the others
atom : STRING
     | ID
     | NUMBER
	 | UUID
	 | TRUE
	 | FALSE

composed : LCURLY RCURLY
         | LBRACE RBRACE
         | LBRACE atoms RBRACE
	     | LCURLY keyvalues RCURLY

atoms : atom COMMA atoms
      | atom

keyvalue : atom COLON atom

keyvalues : keyvalue COMMA keyvalues
          | keyvalue
