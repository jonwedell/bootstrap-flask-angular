# Example Angular App

## Development server

### Initial set up

If you've just checkout out this code, you must first set up your local development environment.
Make sure that you have python3 installed, and then run the following

```bash
./setup_development_environment.sh
```

This will set up a virtual node environment and also install the node modules needed for
the project. This one needs to be ran once.

## Running the server locally

First, make sure you followed the [initial set up instructions](#initial-set-up). Then you must
always activate your local node environment:

```bash
source ./node_env/bin/activate
```

This will put the correct node and ng binaries in your path. Then, run `ng serve` 
to launch the dev server. Navigate to `http://localhost:4200/`. The app will 
automatically reload if you change any of the source files.

## Build and release

First make sure you have sourced the node environment as described
 [above](#running-the-server-locally).
 
Then check the configuration in `./src/app/environments/environment.prod.ts` is correct.
This mainly means checking that the value of `appUrl` is correct. `appUrl` should point to
the location of the back-end server.

Run `ng build --prod` to build the project. The built project will
be stored in the `dist/` directory. To deploy the server, simply copy all the files in the
`dist` directory to your web server, and then use the following nginx configuration:


```
server {
    listen 443 ssl default_server;

    root /path/to/files/in/dist;
    index index.php index.html index.htm;
    client_max_body_size 64M;

    server_name nmrbox.org www.nmrbox.org web.nmrbox.org;
    ssl_certificate /etc/letsencrypt/live/nmrbox.org/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/nmrbox.org/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    location / {
        try_files $uri$args $uri$args/ /index.html;
    }
}

server {
    listen 80 default_server;
    server_name nmrbox.org www.nmrbox.org web.nmrbox.org;

    return 301 https://$host$request_uri;
}

```

The important thing to notice in the configuration above, which is not normally present,
are the lines:

```
location / {
        try_files $uri$args $uri$args/ /index.html;
    }
```

These ensure that when the client browser requests `nmrbox.org/pages/community` the nginx
server instead returns the file `/index.html` which is necessary since the `/pages/community`
part of the URL is interpreted inside of the client Angular code.
