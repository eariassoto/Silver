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
   strTok *string
   numTok *big.Rat
}

%token <strTok> STRING
%token <numTok> NUMBER

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
STRING
NUMBER
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
    INSERT INTO STRING LPAREN columns RPAREN VALUES LPAREN valueslist RPAREN

named : NAMED STRING

// select
select : base_select
       | base_select where

base_select : SELECT STAR FROM STRING
            | SELECT columns FROM STRING

// update
update : UPDATE STRING SET assignments
       | UPDATE STRING SET assignments where

// mutate
mutate : MUTATE STRING APPLY mutations
       | UPDATE STRING APPLY mutations where

// delete
delete : DELETE STRING
       | DELETE STRING where


assignments : assignment COMMA assignments
            | assignment

assignment : STRING EQUALS value

columns : STRING COMMA columns
        | STRING

where : WHERE conditions

conditions : condition COMMA conditions
           | condition

condition : STRING function value

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

mutation : STRING mutator value

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
     | NUMBER

composed : LCURLY RCURLY
         | LBRACE RBRACE
         | LBRACE atoms RBRACE
	     | LCURLY keyvalues RCURLY

atoms : atom COMMA atoms
      | atom

keyvalue : atom COLON atom

keyvalues : keyvalue COMMA keyvalues
          | keyvalue
