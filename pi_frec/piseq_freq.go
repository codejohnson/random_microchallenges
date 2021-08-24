//
//this is a simple code to find repited digit or binary patterns in a pi number text file.
//
package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"sort"
	"strconv"
)

func show_header() {
	println("Frecquencies of pi digit segments with repeated digits")
	println("- - - - - - - - - - - - - - - - - - - - -  D  I  G  I  T  S  - - - - - - - - - - - - - - - - - - - - - - - - - - ")
	fmt.Printf("%10s", "Long-Seq")
	for d := 0; d <= 9; d++ {
		fmt.Printf("%10d", d)
	}
	println()
	println("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ")
}

func show_results(result map[int][]int) {
	show_header()
	keys := sorted_repetitions(result)
	for _, size := range keys {
		fmt.Printf("%10d", size)
		for dig := '0'; dig <= '9'; dig++ {
			fmt.Printf("%10d", result[size][dig-48])
		}
		println()
	}
}

func get_pi_from_file(filename string) string {
	data, err := ioutil.ReadFile(filename)
	pi := string(data)
	if err == nil {
		return pi[2:]
	}
	return ""
}

///  search largest patterns of repetitions
func search(pi string, width int) map[int][]int {
	seqs := make(map[int][]int)
	start := 0
	for i := 1; i < len(pi); i++ {
		if pi[start] != pi[i] {
			if i-start >= width {
				size := i - start
				if _, found := seqs[size]; !found {
					seqs[size] = []int{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
				}
				seqs[size][pi[start]-'0']++
			}
			start = i
		}
	}
	return seqs
}

func sorted_repetitions(m map[int][]int) []int {
	keys := make([]int, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Ints(keys)
	return keys
}

/*
  entry point:
	get command arguments, and calls to search function to solve the test case
*/
func main() {
	if len(os.Args) == 3 {
		width, err := strconv.Atoi(os.Args[2])
		if err != nil {
			println("incorrect argument: width of min sequence is not a valid integer value.")
		} else {
			pi := get_pi_from_file(os.Args[1]) //get Pi number into memory (1Gb is ok for memory in this case)
			reps := search(pi, width)          //search sequences in Pi number
			show_results(reps)
		}
	} else {
		println("argument missing: please especify filepath and minimum width.")
	}
}
