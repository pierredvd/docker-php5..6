# Force active vhosts
(for d in `ls /etc/apache2/sites-available`;do a2ensite $d; done); 
#a2enmod headers
#a2enmod opcache, headers, rewrite, ssl
# Restart apache2
service apache2 restart

