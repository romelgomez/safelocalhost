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
