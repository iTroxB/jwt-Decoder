#!/bin/bash

sudo apt update -y
sudo apt install jq openssl coreutils golang-go -y

go build -o jwtBruteForce jwtBruteForce.go