# nginx-guacamole

## Install

Prerequisite: Install the [reverse proxy](https://github.com/Starli0n/nginx-proxy)

```sh
> git clone https://github.com/Starli0n/nginx-guacamole
> cd nginx-guacamole
> make env
(tweak .env file)
> make guacamole
```

## Configure

- Customize the `.env` file after the first `make env`


## URL

http://HOSTNAME:8080/guacamole

- Username: guacadmin
- Password: guacadmin


## POSTGRES

```
psql -h postgres -U guacamole_user -d guacamole_db
```

## SSH

For SSH Connection protocol, use those commands to genereate SSH private key:

```
mkdir .ssh
KEYFILE=$PWD/.ssh/id_guacamole_rsa
openssl genrsa -out ${KEYFILE} -passout stdin 4096
ssh-keygen -y -f ${KEYFILE} > ${KEYFILE}.pub
echo -n " guacamole@no-reply.com" >> ${KEYFILE}.pub
```

Header should be: `-----BEGIN RSA PRIVATE KEY-----`

DO NOT USE:

```
ssh-keygen -t rsa -b 4096 -C "guacamole@no-reply.com" -f "$PWD/.ssh/id_guacamole_rsa"
```

https://issues.apache.org/jira/browse/GUACAMOLE-745?focusedCommentId=17191235&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-17191235
