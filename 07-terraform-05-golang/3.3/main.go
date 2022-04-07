package main

import "fmt"

func createNumbers(lo int, hi int) []int {
	s := make([]int, hi-lo+1)
	for i := range s {
		s[i] = i + lo
	}
	return s
}

func main() {
	for _, value := range createNumbers(1, 100) {
		if value%3 == 0 {
			fmt.Println(value)
		}
	}
}
