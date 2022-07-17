package main

import "fmt"

func main() {
	for number := 1; number <= 100; number++ {
		if number%3 == 0 {
			fmt.Println(number)
		}
	}
}
