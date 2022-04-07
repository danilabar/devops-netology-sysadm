package main

import "fmt"

func main() {
    fmt.Print("Enter meters: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input * 3.28084

    fmt.Println(output, "ft")
}