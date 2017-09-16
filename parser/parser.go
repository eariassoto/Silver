//line parser/parser.y:26
package parser

import __yyfmt__ "fmt"

//line parser/parser.y:26
import (
	"fmt"
	"math/big"
)

func Parse(lex *lexer) {
	yyParse(lex)
}

//line parser/parser.y:38
type yySymType struct {
	yys    int
	strTok *string
	numTok *big.Rat
}

const STRING = 57346
const NUMBER = 57347
const LPAREN = 57348
const RPAREN = 57349
const STAR = 57350
const COMMA = 57351
const LCURLY = 57352
const RCURLY = 57353
const LBRACE = 57354
const RBRACE = 57355
const EQUALS = 57356
const LE = 57357
const LT = 57358
const GE = 57359
const GT = 57360
const EQ = 57361
const NE = 57362
const COLON = 57363
const SEMICOLON = 57364
const INCR = 57365
const DECR = 57366
const MULT = 57367
const DIV = 57368
const MOD = 57369
const INSERT = 57370
const INTO = 57371
const VALUES = 57372
const NAMED = 57373
const SELECT = 57374
const FROM = 57375
const UPDATE = 57376
const SET = 57377
const MUTATE = 57378
const APPLY = 57379
const DELETE = 57380
const WHERE = 57381
const AND = 57382
const OR = 57383
const INCLUDES = 57384
const EXCLUDES = 57385
const MUT_INS = 57386
const MUT_DEL = 57387

var yyToknames = [...]string{
	"$end",
	"error",
	"$unk",
	"STRING",
	"NUMBER",
	"LPAREN",
	"RPAREN",
	"STAR",
	"COMMA",
	"LCURLY",
	"RCURLY",
	"LBRACE",
	"RBRACE",
	"EQUALS",
	"LE",
	"LT",
	"GE",
	"GT",
	"EQ",
	"NE",
	"COLON",
	"SEMICOLON",
	"INCR",
	"DECR",
	"MULT",
	"DIV",
	"MOD",
	"INSERT",
	"INTO",
	"VALUES",
	"NAMED",
	"SELECT",
	"FROM",
	"UPDATE",
	"SET",
	"MUTATE",
	"APPLY",
	"DELETE",
	"WHERE",
	"AND",
	"OR",
	"INCLUDES",
	"EXCLUDES",
	"MUT_INS",
	"MUT_DEL",
}
var yyStatenames = [...]string{}

const yyEofCode = 1
const yyErrCode = 2
const yyInitialStackSize = 16

//line yacctab:1
var yyExca = [...]int{
	-1, 1,
	1, -1,
	-2, 0,
}

const yyPrivate = 57344

const yyLast = 119

var yyAct = [...]int{

	106, 64, 89, 85, 107, 26, 54, 51, 19, 76,
	77, 78, 79, 80, 30, 20, 43, 44, 45, 46,
	47, 48, 33, 39, 34, 35, 38, 18, 101, 24,
	81, 82, 36, 28, 16, 98, 72, 99, 96, 66,
	67, 109, 57, 49, 50, 13, 61, 63, 88, 14,
	100, 10, 97, 11, 74, 12, 62, 71, 66, 67,
	70, 66, 67, 73, 83, 84, 105, 68, 41, 69,
	87, 90, 40, 108, 27, 95, 56, 92, 25, 91,
	94, 93, 66, 67, 53, 58, 27, 32, 60, 59,
	37, 29, 23, 22, 21, 2, 86, 15, 65, 87,
	103, 102, 90, 104, 75, 55, 42, 31, 52, 9,
	110, 17, 8, 7, 6, 5, 4, 3, 1,
}
var yyPact = [...]int{

	17, 17, 12, -1000, -1000, -1000, -1000, -1000, -4, -24,
	90, 89, 88, 0, 70, 11, -1000, -1000, 87, -1000,
	83, -13, -12, -24, 86, -7, -10, 63, -1000, -1000,
	-1000, 59, 1, 80, 72, 72, -1000, 79, 85, 84,
	82, 83, 57, -1000, -1000, -1000, -1000, -1000, -1000, -1000,
	-1000, -24, 48, 22, -24, 45, -14, -1000, 82, -1000,
	-1000, -1000, -1000, -1000, -1000, -1000, -1000, -1000, 54, 35,
	-1000, 80, 57, -1000, 72, 57, -1000, -1000, -1000, -1000,
	-1000, -1000, -1000, 68, -1000, 27, 43, 14, -1000, 24,
	41, -1000, -1000, -1000, -1000, -2, -1000, 78, 78, -1000,
	78, 60, -1000, -1000, -1000, 57, 66, 32, -1000, 57,
	-1000,
}
var yyPgo = [...]int{

	0, 118, 95, 117, 116, 115, 114, 113, 112, 111,
	5, 0, 109, 8, 7, 6, 108, 4, 14, 107,
	106, 105, 104, 1, 98, 2, 3, 96,
}
var yyR1 = [...]int{

	0, 1, 1, 2, 2, 2, 2, 2, 3, 3,
	8, 9, 4, 4, 12, 12, 5, 5, 6, 6,
	7, 7, 14, 14, 16, 10, 10, 13, 18, 18,
	19, 20, 20, 20, 20, 20, 20, 20, 20, 15,
	15, 21, 22, 22, 22, 22, 22, 22, 22, 11,
	11, 17, 17, 23, 23, 24, 24, 24, 24, 25,
	25, 27, 26, 26,
}
var yyR2 = [...]int{

	0, 3, 2, 1, 1, 1, 1, 1, 1, 2,
	10, 2, 1, 2, 4, 4, 4, 5, 4, 5,
	2, 3, 3, 1, 3, 3, 1, 2, 3, 1,
	3, 1, 1, 1, 1, 1, 1, 1, 1, 3,
	1, 3, 1, 1, 1, 1, 1, 1, 1, 3,
	1, 1, 1, 1, 1, 2, 2, 3, 3, 3,
	1, 3, 3, 1,
}
var yyChk = [...]int{

	-1000, -1, -2, -3, -4, -5, -6, -7, -8, -12,
	34, 36, 38, 28, 32, -2, 22, -9, 31, -13,
	39, 4, 4, 4, 29, 8, -10, 4, 22, 4,
	-18, -19, 4, 35, 37, 37, -13, 4, 33, 33,
	9, 9, -20, 15, 16, 17, 18, 19, 20, 42,
	43, -14, -16, 4, -15, -21, 4, -15, 6, 4,
	4, -10, -18, -17, -23, -24, 4, 5, 10, 12,
	-13, 9, 14, -13, 9, -22, 23, 24, 25, 26,
	27, 44, 45, -10, 11, -26, -27, -23, 13, -25,
	-23, -14, -17, -15, -17, 7, 11, 9, 21, 13,
	9, 30, -26, -23, -25, 6, -11, -17, 7, 9,
	-11,
}
var yyDef = [...]int{

	0, -2, 0, 3, 4, 5, 6, 7, 8, 12,
	0, 0, 0, 0, 0, 0, 2, 9, 0, 13,
	0, 0, 0, 20, 0, 0, 0, 26, 1, 11,
	27, 29, 0, 0, 0, 0, 21, 0, 0, 0,
	0, 0, 0, 31, 32, 33, 34, 35, 36, 37,
	38, 16, 23, 0, 0, 40, 0, 18, 0, 14,
	15, 25, 28, 30, 51, 52, 53, 54, 0, 0,
	17, 0, 0, 19, 0, 0, 42, 43, 44, 45,
	46, 47, 48, 0, 55, 0, 63, 0, 56, 0,
	60, 22, 24, 39, 41, 0, 58, 0, 0, 57,
	0, 0, 62, 61, 59, 0, 0, 50, 10, 0,
	49,
}
var yyTok1 = [...]int{

	1,
}
var yyTok2 = [...]int{

	2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
	12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
	22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
	32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
	42, 43, 44, 45,
}
var yyTok3 = [...]int{
	0,
}

var yyErrorMessages = [...]struct {
	state int
	token int
	msg   string
}{}

//line yaccpar:1

/*	parser for yacc output	*/

var (
	yyDebug        = 0
	yyErrorVerbose = false
)

type yyLexer interface {
	Lex(lval *yySymType) int
	Error(s string)
}

type yyParser interface {
	Parse(yyLexer) int
	Lookahead() int
}

type yyParserImpl struct {
	lval  yySymType
	stack [yyInitialStackSize]yySymType
	char  int
}

func (p *yyParserImpl) Lookahead() int {
	return p.char
}

func yyNewParser() yyParser {
	return &yyParserImpl{}
}

const yyFlag = -1000

func yyTokname(c int) string {
	if c >= 1 && c-1 < len(yyToknames) {
		if yyToknames[c-1] != "" {
			return yyToknames[c-1]
		}
	}
	return __yyfmt__.Sprintf("tok-%v", c)
}

func yyStatname(s int) string {
	if s >= 0 && s < len(yyStatenames) {
		if yyStatenames[s] != "" {
			return yyStatenames[s]
		}
	}
	return __yyfmt__.Sprintf("state-%v", s)
}

func yyErrorMessage(state, lookAhead int) string {
	const TOKSTART = 4

	if !yyErrorVerbose {
		return "syntax error"
	}

	for _, e := range yyErrorMessages {
		if e.state == state && e.token == lookAhead {
			return "syntax error: " + e.msg
		}
	}

	res := "syntax error: unexpected " + yyTokname(lookAhead)

	// To match Bison, suggest at most four expected tokens.
	expected := make([]int, 0, 4)

	// Look for shiftable tokens.
	base := yyPact[state]
	for tok := TOKSTART; tok-1 < len(yyToknames); tok++ {
		if n := base + tok; n >= 0 && n < yyLast && yyChk[yyAct[n]] == tok {
			if len(expected) == cap(expected) {
				return res
			}
			expected = append(expected, tok)
		}
	}

	if yyDef[state] == -2 {
		i := 0
		for yyExca[i] != -1 || yyExca[i+1] != state {
			i += 2
		}

		// Look for tokens that we accept or reduce.
		for i += 2; yyExca[i] >= 0; i += 2 {
			tok := yyExca[i]
			if tok < TOKSTART || yyExca[i+1] == 0 {
				continue
			}
			if len(expected) == cap(expected) {
				return res
			}
			expected = append(expected, tok)
		}

		// If the default action is to accept or reduce, give up.
		if yyExca[i+1] != 0 {
			return res
		}
	}

	for i, tok := range expected {
		if i == 0 {
			res += ", expecting "
		} else {
			res += " or "
		}
		res += yyTokname(tok)
	}
	return res
}

func yylex1(lex yyLexer, lval *yySymType) (char, token int) {
	token = 0
	char = lex.Lex(lval)
	if char <= 0 {
		token = yyTok1[0]
		goto out
	}
	if char < len(yyTok1) {
		token = yyTok1[char]
		goto out
	}
	if char >= yyPrivate {
		if char < yyPrivate+len(yyTok2) {
			token = yyTok2[char-yyPrivate]
			goto out
		}
	}
	for i := 0; i < len(yyTok3); i += 2 {
		token = yyTok3[i+0]
		if token == char {
			token = yyTok3[i+1]
			goto out
		}
	}

out:
	if token == 0 {
		token = yyTok2[1] /* unknown char */
	}
	if yyDebug >= 3 {
		__yyfmt__.Printf("lex %s(%d)\n", yyTokname(token), uint(char))
	}
	return char, token
}

func yyParse(yylex yyLexer) int {
	return yyNewParser().Parse(yylex)
}

func (yyrcvr *yyParserImpl) Parse(yylex yyLexer) int {
	var yyn int
	var yyVAL yySymType
	var yyDollar []yySymType
	_ = yyDollar // silence set and not used
	yyS := yyrcvr.stack[:]

	Nerrs := 0   /* number of errors */
	Errflag := 0 /* error recovery flag */
	yystate := 0
	yyrcvr.char = -1
	yytoken := -1 // yyrcvr.char translated into internal numbering
	defer func() {
		// Make sure we report no lookahead when not parsing.
		yystate = -1
		yyrcvr.char = -1
		yytoken = -1
	}()
	yyp := -1
	goto yystack

ret0:
	return 0

ret1:
	return 1

yystack:
	/* put a state and value onto the stack */
	if yyDebug >= 4 {
		__yyfmt__.Printf("char %v in %v\n", yyTokname(yytoken), yyStatname(yystate))
	}

	yyp++
	if yyp >= len(yyS) {
		nyys := make([]yySymType, len(yyS)*2)
		copy(nyys, yyS)
		yyS = nyys
	}
	yyS[yyp] = yyVAL
	yyS[yyp].yys = yystate

yynewstate:
	yyn = yyPact[yystate]
	if yyn <= yyFlag {
		goto yydefault /* simple state */
	}
	if yyrcvr.char < 0 {
		yyrcvr.char, yytoken = yylex1(yylex, &yyrcvr.lval)
	}
	yyn += yytoken
	if yyn < 0 || yyn >= yyLast {
		goto yydefault
	}
	yyn = yyAct[yyn]
	if yyChk[yyn] == yytoken { /* valid shift */
		yyrcvr.char = -1
		yytoken = -1
		yyVAL = yyrcvr.lval
		yystate = yyn
		if Errflag > 0 {
			Errflag--
		}
		goto yystack
	}

yydefault:
	/* default state action */
	yyn = yyDef[yystate]
	if yyn == -2 {
		if yyrcvr.char < 0 {
			yyrcvr.char, yytoken = yylex1(yylex, &yyrcvr.lval)
		}

		/* look through exception table */
		xi := 0
		for {
			if yyExca[xi+0] == -1 && yyExca[xi+1] == yystate {
				break
			}
			xi += 2
		}
		for xi += 2; ; xi += 2 {
			yyn = yyExca[xi+0]
			if yyn < 0 || yyn == yytoken {
				break
			}
		}
		yyn = yyExca[xi+1]
		if yyn < 0 {
			goto ret0
		}
	}
	if yyn == 0 {
		/* error ... attempt to resume parsing */
		switch Errflag {
		case 0: /* brand new error */
			yylex.Error(yyErrorMessage(yystate, yytoken))
			Nerrs++
			if yyDebug >= 1 {
				__yyfmt__.Printf("%s", yyStatname(yystate))
				__yyfmt__.Printf(" saw %s\n", yyTokname(yytoken))
			}
			fallthrough

		case 1, 2: /* incompletely recovered error ... try again */
			Errflag = 3

			/* find a state where "error" is a legal shift action */
			for yyp >= 0 {
				yyn = yyPact[yyS[yyp].yys] + yyErrCode
				if yyn >= 0 && yyn < yyLast {
					yystate = yyAct[yyn] /* simulate a shift of "error" */
					if yyChk[yystate] == yyErrCode {
						goto yystack
					}
				}

				/* the current p has no shift on "error", pop stack */
				if yyDebug >= 2 {
					__yyfmt__.Printf("error recovery pops state %d\n", yyS[yyp].yys)
				}
				yyp--
			}
			/* there is no state on the stack with an error shift ... abort */
			goto ret1

		case 3: /* no shift yet; clobber input char */
			if yyDebug >= 2 {
				__yyfmt__.Printf("error recovery discards %s\n", yyTokname(yytoken))
			}
			if yytoken == yyEofCode {
				goto ret1
			}
			yyrcvr.char = -1
			yytoken = -1
			goto yynewstate /* try again in the same state */
		}
	}

	/* reduction by production yyn */
	if yyDebug >= 2 {
		__yyfmt__.Printf("reduce %v in:\n\t%v\n", yyn, yyStatname(yystate))
	}

	yynt := yyn
	yypt := yyp
	_ = yypt // guard against "declared and not used"

	yyp -= yyR2[yyn]
	// yyp is now the index of $0. Perform the default action. Iff the
	// reduced production is ε, $1 is possibly out of range.
	if yyp+1 >= len(yyS) {
		nyys := make([]yySymType, len(yyS)*2)
		copy(nyys, yyS)
		yyS = nyys
	}
	yyVAL = yyS[yyp+1]

	/* consult goto table to find next state */
	yyn = yyR1[yyn]
	yyg := yyPgo[yyn]
	yyj := yyg + yyS[yyp].yys + 1

	if yyj >= yyLast {
		yystate = yyAct[yyg]
	} else {
		yystate = yyAct[yyj]
		if yyChk[yystate] != -yyn {
			yystate = yyAct[yyg]
		}
	}
	// dummy call; replaced with literal code
	switch yynt {

	case 2:
		yyDollar = yyS[yypt-2 : yypt+1]
		//line parser/parser.y:96
		{
			fmt.Println("Got a valid SQL operation")
		}
	}
	goto yystack /* stack new state and value */
}
