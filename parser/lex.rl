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

package parser


import (
	"math/big"
	"fmt"
)

%%{
    machine sql;
    write data;
    access lex.;
    variable p lex.p;
    variable pe lex.pe;
}%%

type lexer struct {
    data []byte
    p, pe, cs int
    ts, te, act int
}


func NewLexer(data []byte) *lexer {
    lex := &lexer{ 
        data: data,
        pe: len(data),
    }
    %% write init;
    return lex
}

/*
*/

func (lex *lexer) Lex(out *yySymType) int {
    eof := lex.pe
    tok := 0
    %%{ 
        main := |*
            ("+"|"-")?.(digit+ | digit+.".".digit+) => {
				numStr := string(lex.data[lex.ts:lex.te])
				out.numTok = &big.Rat{};
				_, ok := out.numTok.SetString(numStr);
				if !ok {
					fmt.Printf("bad number")
					// TODO make this a const
					return 0
				}
				tok = NUMBER;
				fbreak;
			};
			'\"'./[0-9A-Fa-f]/{8}.'-'./[0-9A-Fa-f]/{4}.'-'./[0-9A-Fa-f]/{4}.'-'./[0-9A-Fa-f]/{4}.'-'./[0-9A-Fa-f]/{12}.'\"' => {
				str := string(lex.data[lex.ts:lex.te])
				out.strTok = &str
				tok = UUID; fbreak;
			};
			'\(' => { tok = LPAREN; fbreak;};
			'\)' => { tok = RPAREN; fbreak;};
			'\[' => { tok = LBRACE; fbreak;};
			'\]' => { tok = RBRACE; fbreak;};
			'\*' => { tok = STAR; fbreak;};
			',' => { tok = COMMA; fbreak;};
			'\{' => { tok = LCURLY; fbreak;};
			'\}' => { tok = RCURLY; fbreak;};
			'=' => { tok = EQUALS; fbreak;};
			'<=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = LE; fbreak;
			};
			'<' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = LT; fbreak;
			};
			'>=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = GE; fbreak;
			};
			'>' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = GT; fbreak;
			};
			'==' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = EQ; fbreak;
			};
			'!=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = NE; fbreak;
			};
			':' => { tok = COLON; fbreak;};
			';' => { tok = SEMICOLON; fbreak;};
			'insert'i => { tok = INSERT; fbreak;};
			'into'i => { tok = INTO; fbreak;};
			'values'i => { tok = VALUES; fbreak;};
			'named'i => { tok = NAMED; fbreak;};
			'select'i => { tok = SELECT; fbreak;};
			'from'i => { tok = FROM; fbreak;};
			'update'i => { tok = UPDATE; fbreak;};
			'mutate'i => { tok = MUTATE; fbreak;};
			'apply'i => { tok = APPLY; fbreak;};
			'set'i => { tok = SET; fbreak;};
			'delete'i => { tok = DELETE; fbreak;};
			'where'i => { tok = WHERE; fbreak;};
			'and'i => { tok = AND; fbreak;};
			'or'i => { tok = OR; fbreak;};
			'true'i => {
				out.boolTok = true
				tok = TRUE; fbreak;
			};
			'false'i => {
				out.boolTok = false
				tok = TRUE; fbreak;
			};
			'+=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = INCR; fbreak;
			};
			'-=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = DECR; fbreak;
			};
			'*=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = MULT; fbreak;
			};
			'/=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = DIV; fbreak;
			};
			'%=' => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = MOD; fbreak;
			};
			'add'i => {
				tok = ADD; fbreak;
			};
			'remove'i => {
				tok = REMOVE; fbreak;
			};
			'includes'i => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = INCLUDES; fbreak;
			};
			'excludes'i => {
				str := string(lex.data[lex.ts:lex.te])	
				out.strTok = &str
				tok = EXCLUDES; fbreak;
			};
			'\"'./[a-zA-Z_][a-zA-Z_0-9]*/.'\"' => {
				str := string(lex.data[lex.ts:lex.te])
				out.strTok = &str
				tok = ID;
				fbreak;
			};
			'\"'.(any -- '\"')*.'\"' => {
				str := string(lex.data[lex.ts:lex.te])
				out.strTok = &str
				tok = STRING;
				fbreak;
			};
            space;
        *|;
         write exec;
    }%%

    return tok;
}

func (lex *lexer) Error(e string) {
    fmt.Println("error:", e)
}
