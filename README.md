# Create certificates to support https in localhost with Angular

## Steps

- Open a terminal
- Run in it: `source safelocalhost.sh`
- Go to the chrome browser, and enter in the browser bar: `chrome://settings/certificates`
- Select the Tab: `Authorities`
- Select the generated file: `/safelocalhost/temp/root_crt.crt`
- Mark all the checkboxs of the **Trust settings**
- Get the full path location of the `server.crt` and `server.key` files generated.
- Run:

```sh
ng serve --ssl true --ssl-cert $HOME"/Desktop/projects/safelocalhost/temp/server.crt" --ssl-key $HOME"/Desktop/projects/safelocalhost/temp/server.key"
```

- Then go to https://localhost/

## Ref

- [how-to-get-https-working-on-your-local-development-environment-in-5-minutes](https://www.freecodecamp.org/news/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec/)

- [how-do-i-install-a-root-certificate](https://askubuntu.com/questions/73287/how-do-i-install-a-root-certificate)

- [adding-a-self-signed-certificate-to-the-trusted-list](https://unix.stackexchange.com/questions/90450/adding-a-self-signed-certificate-to-the-trusted-list)

- [running-angular-cli-over-https-with-a-trusted-certificate](https://medium.com/@rubenvermeulen/running-angular-cli-over-https-with-a-trusted-certificate-4a0d5f92747a)
- [how-to-generate-an-openssl-key-using-a-passphrase-from-the-command-line](https://stackoverflow.com/questions/4294689/how-to-generate-an-openssl-key-using-a-passphrase-from-the-command-line)

- [what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file](https://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file)


## How to install certificates for command line

- ref: https://askubuntu.com/questions/645818/how-to-install-certificates-for-command-line

> comment: on Ubuntu 16.04 after adding the CA to /usr/local/share/ca-certificates I had to use `sudo dpkg-reconfigure ca-certificates` for it to pickup the CA.


TL;DR

For everything to work and not only your browser, you need to add that CA certificate to the system's trusted CA repository.

In ubuntu:

Go to /usr/local/share/ca-certificates/
Create a new folder, i.e. "sudo mkdir school"
Copy the .crt file into the school folder
Make sure the permissions are OK (755 for the folder, 644 for the file)
Run "sudo update-ca-certificates"
Why

Let me explain what is going on also, so the other posters see why they don't need any certificate to use Github over HTTPS.

What is going on there is that your school is intercepting all the SSL communications, probably in order to monitor them.

To do that, what they do is in essence a "man in the middle" attack, and because of that, your browser complains rightfully that he is not being able to verify github's certificate. Your school proxy is taking out github's cert and instead providing its own cert.

When your browser tries to verify the school's provided cert against the CA that signed github's cert, it rightfully fails.

So, for the SSL connection to work in the school, you need to consciously accept that "MITM" attack. And you do that by adding the school's CA certificate as a trusted one.

When you trust that school CA, your verification of the fake github cert will work, since the fake github cert will be verified by the school CA.

Be aware that SSL connection is not safe anymore since your school administrator will be able to intercept all your encrypted connections.
