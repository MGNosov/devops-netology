package main

import "testing"

func TestMain(t *testing.T) {
	var x float64
	x = input(5)
	if x != 16.4042 {
		t.Error("Wrong")
	}

}
