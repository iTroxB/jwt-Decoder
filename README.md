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

* Install the requirements by running **requirements-arch.sh** for Arch Linux distros

```shell
sudo bash /opt/jwt-Decoder/requirements-arch.sh
```

or **requirements-debian.sh** for Debian distros

```shell
sudo bash /opt/jwt-Decoder/requirements-debian.sh
```

* Run install.sh to compile file in Go and build symbolic links

```shell
sudo bash /opt/jwt-Decoder/install.sh
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

- Execution on regular JWT without secret signature
 
<div align="center">
  <img src="/img/jwt-Regular.png" width=900px>
</div>

- Execution on base64-encoded JWT without secret signature
 
<div align="center">
  <img src="/img/jwt-Decode-Base64.png" width=900px>
</div>

- Correct signature on dictionary line 103.890

<div align="center">
  <img src="/img/jwt-line-bruteforcing.png" width=900px>
</div>

- Cracking with Go over base64-encoded JWT with secret signature “T3ST1NG_S1GN4TUR3!”
<div align="center">
  <img src="/img/jwt-cracking.png" width=900px>
</div>
