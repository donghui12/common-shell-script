package main

import (
	"fmt"
	"strconv"
	"time"
)

func main() {
	timestampStr := strconv.FormatInt(time.Now().Unix(), 10)
	fmt.Print("时间戳:", timestampStr)
}
