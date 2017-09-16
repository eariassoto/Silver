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

package main


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


func newLexer(data []byte) *lexer {
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
            digit+ => {
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
			'\(' => { tok = LPAREN; fbreak;};
			'\)' => { tok = RPAREN; fbreak;};
			'\[' => { tok = LBRACE; fbreak;};
			'\]' => { tok = RBRACE; fbreak;};
			'\*' => { tok = STAR; fbreak;};
			',' => { tok = COMMA; fbreak;};
			'\{' => { tok = LCURLY; fbreak;};
			'\}' => { tok = RCURLY; fbreak;};
			'=' => { tok = EQUALS; fbreak;};
			'\"<=\"' => { tok = LE; fbreak;};
			'\"<\"' => { tok = LT; fbreak;};
			'\">=\"' => { tok = GE; fbreak;};
			'\">\"' => { tok = GT; fbreak;};
			'\"==\"' => { tok = EQ; fbreak;};
			'\"!=\"' => { tok = NE; fbreak;};
			':' => { tok = COLON; fbreak;};
			';' => { tok = SEMICOLON; fbreak;};
			'insert' => { tok = INSERT; fbreak;};
			'into' => { tok = INTO; fbreak;};
			'values' => { tok = VALUES; fbreak;};
			'named' => { tok = NAMED; fbreak;};
			'select' => { tok = SELECT; fbreak;};
			'from' => { tok = FROM; fbreak;};
			'update' => { tok = UPDATE; fbreak;};
			'mutate' => { tok = MUTATE; fbreak;};
			'apply' => { tok = APPLY; fbreak;};
			'set' => { tok = SET; fbreak;};
			'delete' => { tok = DELETE; fbreak;};
			'where' => { tok = WHERE; fbreak;};
			'and' => { tok = AND; fbreak;};
			'or' => { tok = OR; fbreak;};
			'\"insert\"' => { tok = MUT_INS; fbreak;};
			'\"delete\"' => { tok = MUT_DEL; fbreak;};
			'\"includes\"' => { tok = INCLUDES; fbreak;};
			'\"excludes\"' => { tok = EXCLUDES; fbreak;};
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
