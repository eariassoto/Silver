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
	return fmt.Sprintf("[%s, %s]", k.Key.Print(), k.Value.Print())
}

func (m *Map) Print() string {
	if m.Values == nil {
		return "[\"map\", []]"
	}
	str := "[\"map\", ["
	for e := m.Values.Front(); e != nil; e = e.Next() {
		value := e.Value.(Printable)
		str += value.Print()
		if e.Next() != nil {
			str += ","
		}
	}
	str += "]]"
	return str
}

func (m *Mutation) Print() string {
	return fmt.Sprintf("[%s, %s, %s]", *m.ID, m.Mutator.Print(), m.Value.Print())
}

func (c *Condition) Print() string {
	return fmt.Sprintf("[%s, %s, %s]", *c.ID, c.Function.Print(), c.Value.Print())
}

func (a *Assignment) Print() string {
	return fmt.Sprintf("%s:%s", *a.ID, a.Value.Print())
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

func (s *Select) Print() string {
	cols := ""
	conds := ""
	if s.Columns != nil {
		cols += ", \"columns\":["
		for c := s.Columns.Front(); c != nil; c = c.Next() {
			column := c.Value.(Printable)
			cols += column.Print()
			if c.Next() != nil {
				cols += ","
			}
		}
		cols += "]"
	}
	if s.Conditions != nil {
		for c := s.Conditions.Front(); c != nil; c = c.Next() {
			condition := c.Value.(Printable)
			conds += condition.Print()
			if c.Next() != nil {
				conds += ","
			}
		}
	}
	return fmt.Sprintf("{\"op\":\"select\", \"table\":%s%s, \"where\":[%s]}", *s.Table, cols, conds)
}

func (u *Update) Print() string {
	rows := ""
	conds := ""
	for a := u.Assignments.Front(); a != nil; a = a.Next() {
		assignment := a.Value.(Printable)
		rows += assignment.Print()
		if a.Next() != nil {
			rows += ","
		}
	}
	if u.Conditions != nil {
		for c := u.Conditions.Front(); c != nil; c = c.Next() {
			condition := c.Value.(Printable)
			conds += condition.Print()
			if c.Next() != nil {
				conds += ","
			}
		}
	}
	return fmt.Sprintf("{\"op\":\"update\", \"table\":%s, \"where\":[%s], \"rows\":[{%s}}", *u.Table, conds, rows)
}

func (m *Mutate) Print() string {
	muts := ""
	conds := ""
	for m := m.Mutations.Front(); m != nil; m = m.Next() {
		mutation := m.Value.(Printable)
		muts += mutation.Print()
		if m.Next() != nil {
			muts += ","
		}
	}
	if m.Conditions != nil {
		for c := m.Conditions.Front(); c != nil; c = c.Next() {
			condition := c.Value.(Printable)
			conds += condition.Print()
			if c.Next() != nil {
				conds += ","
			}
		}
	}
	return fmt.Sprintf("{\"op\":\"mutate\", \"table\":%s, \"where\":[%s], \"mutations\":[{%s}}", *m.Table, conds, muts)
}

func (d *Delete) Print() string {
	conds := ""
	if d.Conditions != nil {
		for c := d.Conditions.Front(); c != nil; c = c.Next() {
			condition := c.Value.(Printable)
			conds += condition.Print()
			if c.Next() != nil {
				conds += ","
			}
		}
	}
	return fmt.Sprintf("{\"op\":\"delete\", \"table\":%s, \"where\":[%s]}", *d.Table, conds)
}
