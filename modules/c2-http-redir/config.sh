#!/bin/bash
apt-get install -y apache2
a2enmod ssl rewrite proxy proxy_http
a2ensite default-ssl.conf
service apache2 restart
wget -O /etc/apache2/apache2.conf https://pastebin.com/raw/1XeiL1HR

echo -n "<VirtualHost *:80>
	ErrorLog /var/log/apache2/error.log
	CustomLog /var/log/apache2/access.log combined
	
	ProxyRequests Off
	
	ProxyPass /en-us/index.html http://${c2_ip_pass}/en-us/index.html
	ProxyPassReverse /en-us/index.html http://${c2_ip_pass}/en-us/index.html
	
	ProxyPass /en-us/docs.html http://${c2_ip_pass}/en-us/docs.html
        ProxyPassReverse /en-us/docs.html http://${c2_ip_pass}/en-us/docs.html
	
	ProxyPass /en-us/test.html http://${c2_ip_pass}/en-us/test.html
        ProxyPassReverse /en-us/test.html http://${c2_ip_pass}/en-us/test.html

</VirtualHost>
" > /etc/apache2/sites-enabled/000-default.conf

service apache2 restart