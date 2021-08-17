//
//this is a simple code to find repited digit or binary patterns in a pi number text file.
//
package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

const (
	repeat = 0 //constants to improve code readability
	binary = 1
)

/*
  search largest patterns, repetitions or binaries
*/
func search(ptype int, filename string) (string, int) {
	data, err := ioutil.ReadFile(filename)
	pi := string(data)
	if err != nil {
		return "", 0
	}
	start, seq, loc := 2, "", 0
	for i := 3; i < len(pi); i++ {
		if !(ptype == repeat && pi[start] == pi[i] || ptype == binary && pi[i] < '2') {
			if i-start+1 > len(seq) {
				seq = pi[start:i]
				loc = start
			}
			start = i
		}
	}
	if ptype == binary {
		return seq[1:], loc
	}
	return seq, loc
}

/*
  entry point:
	get command arguments, and calls to search function to solve the test case
*/
func main() {
	if len(os.Args) == 2 {
		seq, loc := search(repeat, os.Args[1])
		fmt.Printf("repeated sequence %s in location %d \n", seq, loc)
		seq, loc = search(binary, os.Args[1])
		fmt.Printf("binary sequence %s in location %d \n", seq, loc)
		return
	}
	println("argument error: please especify pi text file.")
}
