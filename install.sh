#!/bin/bash

sudo chmod +x /opt/jwt-Decoder/jwtDecoder.sh
sudo ln -s /opt/jwt-Decoder/jwtDecoder.sh /usr/bin/jwtDecoder

sudo go build -o /opt/jwt-Decoder/jwtBruteForce /opt/jwt-Decoder/jwtBruteForce.go
sudo ln -s /opt/jwt-Decoder/jwtBruteForce /usr/bin/jwtBruteForce
