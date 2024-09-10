#!/bin/bash

sudo chmod +x /opt/jwt-Decoder/jwtDecoder.sh
sudo ln -s /opt/jwt-Decoder/jwtDecoder.sh /usr/bin/jwtDecoder

sudo go build -o /opt/jwt-Decoder/go/jwtBruteForce /opt/jwt-Decoder/go/main.go
sudo ln -s /opt/jwt-Decoder/go/jwtBruteForce /usr/bin/jwtBruteForce
