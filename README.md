
This is an iOS and Android native project that demonstrates how to use WEBRTC and SRS for RTC transport.  

Usage:
mkdir build
cd build
git clone https://github.com/ossrs/srs.git
cd srs/trunk
./configure --osx
make

cd conf
vim debug_rtc_remote_https.conf
or
vim debug_rtc_local_https.conf

// ----------------------- debug remote server -------------------------------------

listen              1935;
max_connections     200;
daemon              off;
srs_log_tank        console;

http_server {
    enabled         on;
    listen          8080;
    dir             ./objs/nginx/html;
    https {
        enabled on;
        listen 8088;
        # listen 443;
        key ./conf/www.google.com.key;
        cert ./conf/www.google.com.pem;
    }
}

http_api {
    enabled         on;
    listen          1985;
    https {
        enabled on;
        # listen 1990;
        listen 443;
        key ./conf/www.google.com.key;
        cert ./conf/www.google.com.pem;
    }
}
stats {
    network         0;
}
rtc_server {
    enabled         on;
    # Listen at udp://8000
    listen          8000;
    #
    # The $CANDIDATE means fetch from env, if not configed, use * as default.
    #
    # The * means retrieving server IP automatically, from all network interfaces,
    # @see https://github.com/ossrs/srs/issues/307#issuecomment-599028124
    # candidate       $CANDIDATE;
    # your remote server public network ip.
    candidate       39.97.171.174;
}

vhost __defaultVhost__ {
    rtc {
        enabled     on;
        bframe      discard;
    }
}

// ----------------------- debug remote server -------------------------------------

// ----------------------- debug localhost server ----------------------------------

listen              1935;
max_connections     200;
daemon              off;
srs_log_tank        console;

http_server {
    enabled         on;
    listen          8080;
    dir             ./objs/nginx/html;
    https {
        enabled on;
        listen 8088;
        key ./conf/localhost_https_server.key;
        cert ./conf/localhost_https_server.crt;
    }
}

http_api {
    enabled         on;
    listen          1985;
    https {
        enabled on;
        # listen 1990;
        listen 443;
        key ./conf/localhost_https_server.key;
        cert ./conf/localhost_https_server.crt;
    }
}
stats {
    network         0;
}
rtc_server {
    enabled         on;
    # Listen at udp://8000
    listen          8000;
    #
    # The $CANDIDATE means fetch from env, if not configed, use * as default.
    #
    # The * means retrieving server IP automatically, from all network interfaces,
    # @see https://github.com/ossrs/srs/issues/307#issuecomment-599028124
    candidate       $CANDIDATE;
    
    # candidate       192.168.3.231;
}

vhost __defaultVhost__ {
    rtc {
        enabled     on;
        bframe      discard;
    }
}


// ----------------------- debug localhost server ----------------------------------

// start srs.
./objs/srs -c conf/debug_rtc_remote_https.conf 
or
./objs/srs -c conf/debug_rtc_local_https.conf 

// stop srs.
./etc/init.d/srs stop

how to create and install localhost https certificate, and make sure chrome trust the certificate please look:
https://github.com/jeffasd/local-cert-generator
https://github.com/jeffasd/local-https-cert

reference origin author:
https://github.com/wsdo/local-https-cert
https://github.com/dakshshah96/local-cert-generator
https://github.com/stasel/WebRTC-iOS


