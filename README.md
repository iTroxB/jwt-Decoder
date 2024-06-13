# jwt-Decoder

<div align="center">
  <img src="/img/jwt-logo.png" width=750px>
</div>

Bash script that decodes JWT tokens, in normal format or fully Base64-encoded.

---

## Install tool

* Download the repository to your system

```shell
sudo git -C /opt clone https://github.com/iTroxB/jwt-Decoder.git
```

* Install the requirements by running **requirements.sh**

```shell
sudo bash /opt/jwt-Decoder/requirements.sh
```

* To use the system-level tool as an executable from a relative path, it is recommended to create a symbolic link to the /usr/bin directory from your repository directory.

```shell
sudo chmod +x /opt/jwt-Decoder/jwtDecoder.sh
sudo ln -s /opt/jwt-Decoder/jwtDecoder.sh /usr/bin/jwtDecoder
```

* To know the options and parameters of the tool run the help menu with the flag `-h` or `--help`.

```shell
jwtDecoder -h
```

```shell
jwtDecoder --help
```

<div align="center">
  <img src="/img/jwt-help.png" width=750px>
</div>

---

## Use tool

- Example of JWT without signature secret

<div align="center">
  <img src="/img/jwt-noSignature.png" width=750px>
</div>

- Example of JWT with secret signature "JSON-WEB-TOKEN"

<div align="center">
  <img src="/img/jwt-Signature.png" width=750px>
</div>

- Execution on base64-encoded JWT without secret signature
  - **Token**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.5Hm3bNazVbnK--vsGWMJ_tmZCviy7qL4T16XJLBtQq0
  - **Base64-encode**: ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnVZVzFsSWpvaVNtOW9iaUJFYjJVaWZRLjVIbTNiTmF6VmJuSy0tdnNHV01KX3RtWkN2aXk3cUw0VDE2WEpMQnRRcTA=

<div align="center">
  <img src="/img/jwt-token1.png" width=1000px>
</div>

- Execution on base64-encoded JWT with brute force attack on secret signature "JSON-WEB-TOKEN"
  - **Token**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.VVrywxLuWdr8seumIsY49n_OL4l_k7xph745wdr9_BM
  - **Base64-encode**: ZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SnVZVzFsSWpvaVNtOW9iaUJFYjJVaWZRLlZWcnl3eEx1V2RyOHNldW1Jc1k0OW5fT0w0bF9rN3hwaDc0NXdkcjlfQk0=
 
<div align="center">
  <img src="/img/jwt-token2.png" width=1000px>
</div>

---
