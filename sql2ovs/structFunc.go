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
	"github.com/eariassoto/Silver/errors"
)

func NewEmptyMap() *Map {
	m := Map{}
	m.Values = nil
	return &m
}

func NewEmptySet() *Set {
	s := Set{}
	s.Values = nil
	return &s
}

func NewInsert(table *string, col *list.List, val *list.List) (*Insert, error) {
	if col.Len() != val.Len() {
		return nil, errors.New("Mismatch between column names and values.")
	}
	return &Insert{table, col, val, nil}, nil
}

func NewNamedInsert(table *string, col *list.List, val *list.List, name *string) (*Insert, error) {
	ins, err := NewInsert(table, col, val)
	if err != nil {
		return nil, err
	}
	ins.UUIDName = name
	return ins, nil
}

func (i *Insert) SetUUIDName(name *string) {
	i.UUIDName = name
}
