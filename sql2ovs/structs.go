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

package sql2ovs

import (
	"container/list"
	"math/big"
)

type Printable interface {
	Print() string
}

type StringValue struct {
	Value *string
}

type NumericValue struct {
	Value *big.Rat
}

type BoolValue struct {
	Value bool
}

type KeyValue struct {
	Key   Printable
	Value Printable
}

type Map struct {
	Values *list.List
}

type Set struct {
	Values *list.List
}

type Mutation struct {
	ID      *string
	Mutator Printable
	Value   Printable
}

type Condition struct {
	ID       *string
	Function Printable
	Value    Printable
}

type Assignment struct {
	ID    *string
	Value Printable
}

type Insert struct {
	Table    *string
	Columns  *list.List
	Values   *list.List
	UUIDName *string
}

type Select struct {
	Table      *string
	Columns    *list.List
	Conditions *list.List
}

type Update struct {
	Table       *string
	Assignments *list.List
	Conditions  *list.List
}

type Mutate struct {
	Table      *string
	Mutations  *list.List
	Conditions *list.List
}

type Delete struct {
	Table      *string
	Conditions *list.List
}
