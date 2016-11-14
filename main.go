package main

import (
	"fmt"
	"os"
)

func cat(filename string) {
	f, err := os.Open(filename)
	defer f.Close()
	if err != nil {
		fmt.Println(err)
		return
	}

	buf := make([]byte, 1024)
	for {
		n, _ := f.Read(buf)
		if 0 == n {
			break
		}
		os.Stdout.Write(buf[:n])
	}

}

func main() {
	cat(os.Args[1])
}
