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
