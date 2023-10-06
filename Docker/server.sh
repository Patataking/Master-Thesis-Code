#!/bin/bash

echo "create key"
openssl ecparam -genkey -name sect163r2 -out key.pem

echo "create csr"
openssl req -new -sha256 -key key.pem -out csr.csr -subj "/C=GB/ST=London/L=London/O=GlobalSecurity/OU=ITDepartment/CN=example.com"


openssl req -x509 -sha256 -days 365 -key key.pem -in csr.csr -out cert.pem


###------------------
echo "start server"
openssl s_server -accept 44330 -key key.pem -cert cert.pem 
###-------------------
 