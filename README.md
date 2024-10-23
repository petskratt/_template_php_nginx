# Simple sample PHP app, containerized

pets@tehnokratt.net / v1.0 2024-10-22

This is a setup template for simple PHP web application consisting of PHP-FPM backend and Nginx web server for ingress.
Both have reasonably safe initial configurations and run rootless.

## Concept

All configuration during deployment is done using app or ingress environment, if current set of configuration files is
not sufficient or there are setting that can not be adjusted configurations files can be added and changed.

Configuration can happen in 4 places (3 envs and `docker-compose.yml`):

* `.env` file - variables used in `docker-compose.yml` (including those for setting app environment there)
* `conf/app.env` file - variables that are passed directly to app container (but can be overridden
  in `docker-compose.yml` environment)
* `conf/nginx.env` file - settings that may need configuration are moved here from `conf/nginx.conf`
  and `conf/templates/*.template` that are used to create configurations in `/etc/nginx/conf.d`

### Running

* Copy `.env.sample` to `.env`, change app name. This file can be also used to store secrets that are then mapped to
  app environment in `docker-compose.yml`.
* Copy `app.env.sample` to `app.env` - app and ingress (nginx) configuration (and possibly secrets) go here.
* Run `./build.sh` to build custom app image and generate selfsigned certs (used in local dev,
  as session cookie uses __Host prefix and needs TLS).
* Run `docker compose up -d` to launch web frontend.

### Logging

Nginx produces JSON logs with some enahancements - including request start ISO8601 timestamp with milliseconds and
upstream data. Log configuration resides in `00-http-common.conf.template` - items presumably not needed are commented
out.

### Tree

```
├── .env.sample                           # Docker env (inc. app name used as prefix)
├── app.env.sample                        # app and ingress (nginx) configuration
├── build.sh
├── Dockerfile
├── docker-compose.yml
├── README.md
├── conf
│   ├── app-php.ini                       # app php.ini for secure configurarion
│   ├── app-fpm.conf                      # app php-fpm configuration
│   ├── nginx.conf                        # nginx main conf file (moved logging to template)
│   └── templates
│       ├── 00-http-common.conf.template  # configuration blocks inside http
│       ├── default.conf.template         # default server configuration (http & https)
│       └── server-common.inc.template    # common parts for http & https                      
└── src
    ├── assets
    │   ├── _variables.scss               # Bootstrap customization (https://bootstrap.build/)
    │   ├── app.js                        # imports Bootstrap + anything custom
    │   ├── app.scss                      # imports Bootstrap + anything custom
    │   ├── package.json                  # Bootstrap & Popper
    │   └── prepros.config                # for building css & min.js, https://prepros.io/
    ├── eggog.html                        # error page
    ├── favicon.ico                       # I hate 404's because of missing favicon
    └── index.php
```

### Why eggog.html?

I learned to program back in 1980's when the only computer you could buy was programmable calculator, so at some time I
had access to Электроника БЗ-21 (60 steps of program, 2 registers for calculation, 7 registers for storage and circular
stack for 6 numbers). 7-segment display... that spelled "error" when you tried to divide by zero or crashed it in any
other clever way (most probably some pirated TI codebase). As the literature about it was in Russian "error" became
"еггог" in cyrillic (transliterating into "eggog"), and of course there was a game where you had to predict duration of
rocket burn to land safely on a far-away planet named еггог - it probably divided your distance from planet with your
vertical speed so you had succeeded in landing if the program ended with "error". Very deep, do not venture into trying
to understand what is eggogology.