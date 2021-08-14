<p><br></p>
<p>This is an iOS and Android native project that demonstrates how to use WEBRTC and SRS for RTC transport.</p>
<p><br></p>
<p>Usage:</p>
<p>mkdir build</p>
<p>cd build</p>
<p>git clone https://github.com/ossrs/srs.git</p>
<p>cd srs/trunk</p>
<p>./configure --osx</p>
<p>make</p>
<p><br></p>
<p>cd conf</p>
<p>vim debug_rtc_remote_https.conf</p>
<p>or</p>
<p>vim debug_rtc_local_https.conf</p>
<p><br></p>
<p>// ----------------------- debug remote server -------------------------------------</p>
<p><br></p>
<p>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>1935;</p>
<p>max_connections <span>&nbsp; &nbsp; </span>200;</p>
<p>daemon<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>off;</p>
<p>srs_log_tank<span>&nbsp; &nbsp; &nbsp; &nbsp; </span>console;</p>
<p><br></p>
<p>http_server {</p>
<p><span>&nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; </span>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>8080;</p>
<p><span>&nbsp; &nbsp; </span>dir <span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>./objs/nginx/html;</p>
<p><span>&nbsp; &nbsp; </span>https {</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>enabled on;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>listen 8088;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span># listen 443;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>key ./conf/www.google.com.key;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>cert ./conf/www.google.com.pem;</p>
<p><span>&nbsp; &nbsp; </span>}</p>
<p>}</p>
<p><br></p>
<p>http_api {</p>
<p><span>&nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; </span>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>1985;</p>
<p><span>&nbsp; &nbsp; </span>https {</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>enabled on;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span># listen 1990;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>listen 443;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>key ./conf/www.google.com.key;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>cert ./conf/www.google.com.pem;</p>
<p><span>&nbsp; &nbsp; </span>}</p>
<p>}</p>
<p>stats {</p>
<p><span>&nbsp; &nbsp; </span>network <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>0;</p>
<p>}</p>
<p>rtc_server {</p>
<p><span>&nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; </span># Listen at udp://8000</p>
<p><span>&nbsp; &nbsp; </span>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>8000;</p>
<p><span>&nbsp; &nbsp; </span>#</p>
<p><span>&nbsp; &nbsp; </span># The $CANDIDATE means fetch from env, if not configed, use * as default.</p>
<p><span>&nbsp; &nbsp; </span>#</p>
<p><span>&nbsp; &nbsp; </span># The * means retrieving server IP automatically, from all network interfaces,</p>
<p><span>&nbsp; &nbsp; </span># @see https://github.com/ossrs/srs/issues/307#issuecomment-599028124</p>
<p><span>&nbsp; &nbsp; </span># candidate <span>&nbsp; &nbsp; &nbsp; </span>$CANDIDATE;</p>
<p><span>&nbsp; &nbsp; </span># your remote server public network ip.</p>
<p><span>&nbsp; &nbsp; </span>candidate <span>&nbsp; &nbsp; &nbsp; </span>39.97.171.174;</p>
<p>}</p>
<p><br></p>
<p>vhost <span>__</span><b>defaultVhost</b><span>__</span> {</p>
<p><span>&nbsp; &nbsp; </span>rtc {</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>bframe<span>&nbsp; &nbsp; &nbsp; </span>discard;</p>
<p><span>&nbsp; &nbsp; </span>}</p>
<p>}</p>
<p><br></p>
<p>// ----------------------- debug remote server -------------------------------------</p>
<p><br></p>
<p>// ----------------------- debug localhost server ----------------------------------</p>
<p><br></p>
<p>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>1935;</p>
<p>max_connections <span>&nbsp; &nbsp; </span>200;</p>
<p>daemon<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>off;</p>
<p>srs_log_tank<span>&nbsp; &nbsp; &nbsp; &nbsp; </span>console;</p>
<p><br></p>
<p>http_server {</p>
<p><span>&nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; </span>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>8080;</p>
<p><span>&nbsp; &nbsp; </span>dir <span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>./objs/nginx/html;</p>
<p><span>&nbsp; &nbsp; </span>https {</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>enabled on;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>listen 8088;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>key ./conf/localhost_https_server.key;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>cert ./conf/localhost_https_server.crt;</p>
<p><span>&nbsp; &nbsp; </span>}</p>
<p>}</p>
<p><br></p>
<p>http_api {</p>
<p><span>&nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; </span>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>1985;</p>
<p><span>&nbsp; &nbsp; </span>https {</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>enabled on;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span># listen 1990;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>listen 443;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>key ./conf/localhost_https_server.key;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>cert ./conf/localhost_https_server.crt;</p>
<p><span>&nbsp; &nbsp; </span>}</p>
<p>}</p>
<p>stats {</p>
<p><span>&nbsp; &nbsp; </span>network <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>0;</p>
<p>}</p>
<p>rtc_server {</p>
<p><span>&nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; &nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; </span># Listen at udp://8000</p>
<p><span>&nbsp; &nbsp; </span>listen<span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span>8000;</p>
<p><span>&nbsp; &nbsp; </span>#</p>
<p><span>&nbsp; &nbsp; </span># The $CANDIDATE means fetch from env, if not configed, use * as default.</p>
<p><span>&nbsp; &nbsp; </span>#</p>
<p><span>&nbsp; &nbsp; </span># The * means retrieving server IP automatically, from all network interfaces,</p>
<p><span>&nbsp; &nbsp; </span># @see https://github.com/ossrs/srs/issues/307#issuecomment-599028124</p>
<p><span>&nbsp; &nbsp; </span>candidate <span>&nbsp; &nbsp; &nbsp; </span>$CANDIDATE;</p>
<p><span>&nbsp;&nbsp; &nbsp;</span></p>
<p><span><span>&nbsp; &nbsp; </span></span># candidate <span>&nbsp; &nbsp; &nbsp; </span>192.168.3.231;</p>
<p>}</p>
<p><br></p>
<p>vhost <span>__</span><b>defaultVhost</b><span>__</span> {</p>
<p><span>&nbsp; &nbsp; </span>rtc {</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>enabled <span>&nbsp; &nbsp; </span>on;</p>
<p><span>&nbsp; &nbsp; &nbsp; &nbsp; </span>bframe<span>&nbsp; &nbsp; &nbsp; </span>discard;</p>
<p><span>&nbsp; &nbsp; </span>}</p>
<p>}</p>
<p><br></p>
<p><br></p>
<p>// ----------------------- debug localhost server ----------------------------------</p>
<p><br></p>
<p>// start srs.</p>
<p>./objs/srs -c conf/debug_rtc_remote_https.conf<span>&nbsp;</span></p>
<p>or</p>
<p>./objs/srs -c conf/debug_rtc_local_https.conf<span>&nbsp;</span></p>
<p><br></p>
<p>// stop srs.</p>
<p>./etc/init.d/srs stop</p>
<p><br></p>
<p>how to create and install localhost https certificate, and make sure chrome trust the certificate please look:</p>
<p>https://github.com/jeffasd/local-cert-generator</p>
<p>https://github.com/jeffasd/local-https-cert</p>
<p><br></p>
<p>reference origin author:</p>
<p>https://github.com/wsdo/local-https-cert</p>
<p>https://github.com/dakshshah96/local-cert-generator</p>
<p>https://github.com/stasel/WebRTC-iOS</p>
<p><br></p>
<p><br></p>
