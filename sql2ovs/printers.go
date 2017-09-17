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
	"fmt"
)

// Print functions
func (s *StringValue) Print() string {
	return *s.Value
}

func (n *NumericValue) Print() string {
	return n.Value.RatString()
}

func (b *BoolValue) Print() string {
	return fmt.Sprintf("%t", b.Value)
}

func (k *KeyValue) Print() string {
	return fmt.Sprintf("[%s, %s]", k.Key, k.Value)
}

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

func (m *Map) Print() string {
	if m.Values != nil {
		return "[\"map\", []]"
	}
	str := "[\"map\", ["
	for e := m.Values.Front(); m.Values != nil; e = e.Next() {
		value, ok := e.Value.(Printable)
		if ok {
			str += value.Print()
			if e.Next() != nil {
				str += ","
			}
		}
	}
	str += "]]"
	return str
}

func (s *Set) Print() string {
	if s.Values != nil {
		return "[\"set\", []]"
	}
	str := "[\"set\", ["
	for e := s.Values.Front(); s.Values != nil; e = e.Next() {
		value, ok := e.Value.(Printable)
		if ok {
			str += value.Print()
			if e.Next() != nil {
				str += ","
			}
		}
	}
	str += "]]"
	return str
}

func (i *Insert) Print() string {
	c := i.Columns.Front()
	row := "{"
	//fmt.Print(i.Values, i.Columns, i.Values.Front())
	for v := i.Values.Front(); v != nil; v = v.Next() {
		column := c.Value.(Printable)
		value := v.Value.(Printable)
		row += column.Print() + ":" + value.Print()
		if v.Next() != nil {
			row += ","
		}
		c = c.Next()
	}
	row += "}"
	name := ""
	if i.UUIDName != nil {
		name = ", \"uuid-name\":" + *i.UUIDName
	}
	return fmt.Sprintf("{\"op\":\"insert\", \"table\":%s, \"row\":%s%s}", *i.Table, row, name)
}
