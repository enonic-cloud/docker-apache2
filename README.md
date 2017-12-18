# Apache2 docker image
Base image for apache2 with ssl module and snakeoil certificates. These however are created at build and should be recreated or replaced. If you want free, easy and secure apache2 with ssl, check out our docker image [enoniccloud/apache2-letsencrypt](https://hub.docker.com/r/enoniccloud/apache2-letsencrypt/)

## Features
- Provides `/server-status` page on port `8001` for easy monitoring.

## Tags
The following tags are available:
- latest, u14.04  ( u14.04/Dockerfile )
- u16.04  ( u16.04/Dockerfile )

### u14.04
Base apache2 image build on ubuntu 14.04

### u16.04
Base apache2 image build on ubuntu 16.04

### u16.04-ondrej
Base apache2 image build on ubuntu 16.04 but added Ondřej Surý apache repository to add a newer version of apache to support http/2

## Guides

### HTTP/2
To enable http/2 support you have to use the `enoniccloud/apache2:u16.04-ondrej` image. This is because ubuntu as of now ( inc. ubuntu 17.10 ) does not ship apache2 with a version that supports http/2.

Create a new `Dockerfile` for your project and base it on the `enoniccloud/apache2:u16.04-ondrej` image. Then enable the module. The file should look like this.
```
FROM enoniccloud/apache2:u16.04-ondrej

RUN a2enmod http2
```
This will enable the http/2 module for apache2.

Now enable the http/2 protocol for either a vhost, or globally dependent to if you specifie the protocols ( `Protocols h2 http/1.1` ) inside a vhost or outside..
```
Protocols http/1.1
<VirtualHost ...>
    ServerName test.example.org
    Protocols h2 http/1.1
</VirtualHost>
```

If you wan't to read mote on http/2, see: https://httpd.apache.org/docs/2.4/howto/http2.html
