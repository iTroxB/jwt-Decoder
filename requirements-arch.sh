#!/bin/bash

sudo pacman -Sy jq openssl coreutils go --noconfirm

go build -o jwtBruteForce jwtBruteForce.go
