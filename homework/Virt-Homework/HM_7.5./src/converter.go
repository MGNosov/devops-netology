package main

import "fmt"

func main() {
	fmt.Print("Enter a number: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := input * 3.28084

	fmt.Println("Here is you feet value:", output)
}
