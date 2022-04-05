#!/bin/bash

# Reference:
# https://docs.microsoft.com/en-us/azure/application-gateway/self-signed-certificates

mkdir certs
cd certs

#####################################################################
# Create the root key
#####################################################################

openssl ecparam -out contoso.key -name prime256v1 -genkey

#####################################################################
# Create a Root Certificate and self-sign it
#####################################################################

# create the root certificate and self-sign it
openssl req -new -sha256 -key contoso.key -out contoso.csr

# generate the root cert
openssl x509 -req -sha256 -days 365 -in contoso.csr -signkey contoso.key -out contoso.crt

#####################################################################
# Create a server certificate
#####################################################################

openssl ecparam -out fabrikam.key -name prime256v1 -genkey

#####################################################################
# Create the CSR (Certificate Signing Request)
#####################################################################

openssl req -new -sha256 -key fabrikam.key -out fabrikam.csr

#####################################################################
# Generate the certificate with the CSR and the key and sign it with the CA's root key
#####################################################################

openssl x509 -req -in fabrikam.csr -CA  contoso.crt -CAkey contoso.key -CAcreateserial -out fabrikam.crt -days 365 -sha256

#####################################################################
# Verify the newly created certificate
#####################################################################

openssl x509 -in fabrikam.crt -text -noout

# Files Generated in your directory should be:
#   contoso.crt
#   contoso.key
#   fabrikam.crt
#   fabrikam.key

#####################################################################
# Generate PFX
#####################################################################

# export to pfx format
openssl pkcs12 -export -in fabrikam.crt -inkey fabrikam.key -out fabrikam.pfx

# New file created:
#   fabrikam.pfx

#####################################################################
# SEE ALSO
#####################################################################

# https://docs.microsoft.com/en-us/azure/application-gateway/certificates-for-backend-authentication
# https://wp.sjkp.dk/creating-self-signed-pfx-and-cer-certificates-with-openssl/
