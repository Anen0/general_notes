# `UBUNTU Checklist in VM`



## `INSTALL PHPMYADMIN`
<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -->
https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-20-04

_additional info_ :
https://www.cloudbooklet.com/install-phpmyadmin-on-ubuntu-20-04-with-apache/


https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-with-nginx-on-an-ubuntu-20-04-server  

-	sudo apt update
-	sudo apt install phpmyadmin
-	Once phpmyadmin is installed, for the Nginx web server to find and serve the phpMyAdmin 
		files correctly, you’ll need to create a symbolic link from the installation files to Nginx’s document root directory:

		sudo ln -s /usr/share/phpmyadmin /var/www/<your_domain>/phpmyadmin
		https://server_domain_or_IP/phpmyadmin
	
***Rename to phpmyadmin*** 

	ls -l
	sudo mv phpmyadmin hiddenlink

***Disable root login***

-	sudo nano /etc/phpmyadmin/conf.d/pma_secure.php
-	add custom settings file inside '/etc/phpmyadmin/conf.d' directory and name it `pma_secure.php`:

		sudo nano /etc/phpmyadmin/conf.d/pma_secure.php

	
		<?php
		# PhpMyAdmin Settings
		# This should be set to a random string of at least 32 chars
		$cfg['blowfish_secret'] = '<CHANGE_THIS_TO_A_STRING_OF_32_RANDOM_CHARACTERS>';

		$i=0;
		$i++;

		$cfg['Servers'][$i]['auth_type'] = 'cookie';
		$cfg['Servers'][$i]['AllowNoPassword'] = false;
		$cfg['Servers'][$i]['AllowRoot'] = false;
		?>

-	to generate passphrase for Blowfish
		
		sudo apt install pwgen
		pwgen -s 32 1
		copy the result to pma_secure.php

-	openssl encryption
		
		openssl rand 60 | openssl base64 -A

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


## `LEMP setup`

https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-20-04  
	
_short rundown_  

	- Install nginx
	- install and setup mysql
	- install php package 
		
		sudo apt install php-fpm php-mysql
	

	nginx config file:  
		server{  
			listen <port>;  
			root /var/www/<domain_name>;  

			location /phpmyadmin {
				alias /var/www/<domain_name>/phpmyadmin/;
				index index.php;
			}

			location ~ \.php$ {
				include snippets/fastcgi-php.conf;
				fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
			}

			location ~ /\.ht {
				deny all;
			}
		}
	

## `APACHE2 change port number`
https://stackoverflow.com/questions/3940909/configure-apache-to-listen-on-port-other-than-80

In /etc/apache2/ports.conf, change the port as

	Listen 8079


Then go to /etc/apache2/sites-enabled/000-default.conf
And change the first line as

	<VirtualHost *: 8079>

Now restart

	sudo service apache2 restart

Apache will now listen on port 8079 and redirect to /var/www/html




## `LAMP set up`

https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04


## `MYSQL-SERVER debugging installation`

if Error displays:	`mysql-server has no installation candidate`  

- you need to download the installation file (.deb) from the web: 

		source:  https://dev.mysql.com/downloads/repo/apt/

- or in terminal  

		
		wget https://repo.mysql.com//mysql-apt-config_0.8.22-1_all.deb	->  downloads the file 
		sudo dpkg -i mysql-apt-config_*********.deb				 		->	installs the file

		sudo apt update
		sudo apt install mysql-server





## `Mount shared folder to VM`

_src_ : https://askubuntu.com/questions/456400/why-cant-i-access-a-shared-folder-from-within-my-virtualbox-machine

1) Highlight the VM, go to Settings > Shared Folders and add folder.
2) Start VM Go to Devices > Insert Guest Additions CD image.
3) Allow VM to run Guest Additions installations.
4) In terminal run: sudo adduser (your user name here) vboxsf
5) Restart VM.






## `REMOTE ACCESSS ON Ubuntu 20.04`

https://dev.to/rakeshgsekhar/how-to-allow-remote-connections-to-mysql-database-on-ubuntu-20-04-4nc2

	mysql --help | grep "Default options" -A 1
	/etc/my.cnf /etc/mysql/my.cnf ~/.my.cnf 

	sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo systemctl restart mysql
	sudo service mysql status



## `VIEW LIST OF SERVICE IN UBUNTU`

https://stackoverflow.com/questions/66314858/how-we-can-see-all-running-services-linux-machine

***SYSTEMCTL***  
	To list all running services on Ubuntu, Type:
	
	systemctl list-units

***SERVICE***  
command will list all services on your Ubuntu Server (both running services and not running services):
	
	service --status-all

Using the grep command, we can filter the output to show only the running services:

	service --status-all | grep '\[ + \]'

To list Ubuntu services that are not running, type:
	
	service --status-all | grep '\[ - \]'

	




# `LIST USERS IN UBUNTU - sudoers list`
<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -->
https://askubuntu.com/questions/410244/is-there-a-command-to-list-all-users-also-to-add-delete-modify-users-in-the

#### To list all local users you can use:
	cut -d: -f1 /etc/passwd

	OR

	getent passwd

#### To add a new user you can use:
	sudo adduser new_username  

	OR

	sudo useradd new_username

#### To remove/delete a user, first you can use:
	sudo userdel username

#### Then you may want to delete the home directory for the deleted user account :
	sudo rm -r /home/username

#### To modify the username of a user:
	usermod -l new_username old_username

#### To change the password for a user:
	sudo passwd username

#### To change the shell for a user:
	sudo chsh username

#### To change the details for a user (for example real name):
	sudo chfn username

#### To add a user to the sudo group:
	adduser username sudo

	or

	usermod -aG sudo username

	or

	usermod -a -G wheel user 

#### List groups

	getent group
	
# `If user is still not part of sudoers  try`:

_Link_	:	https://stackoverflow.com/questions/47806576/username-is-not-in-the-sudoers-file-this-incident-will-be-reported  
	
Open file:  

	sudo su  
	nano /etc/sudoers

Then add the user below admin user like below syntax.  

	user_name ALL=(ALL)  ALL  

#### To restart after changes:
	sudo service sudo restart

	or

	sudo systemctl daemon-reload


## `Move a directory`
	sudo mv fromPath/ toPath/	

## `Rename a directory`
	mv /home/user/oldname /home/user/newname

## `copy`
	sudo cp /old /new




## `Identify the architecture of linux OS`
<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -->
_src_ :  https://unix.stackexchange.com/questions/12453/how-to-determine-linux-kernel-architecture

	dpkg --print-architecture


## `How do I see what packages are installed on Ubuntu Linux?`
<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -->
_src_ : https://www.cyberciti.biz/faq/apt-get-list-packages-are-installed-on-ubuntu-linux/

In terminal:  
		
	apt list --installed

To display a list of packages satisfying certain criteria such as show matching apache2 packages:

	apt list apache2

## `Want to get a list of all upgradeable packages?` Try:

	apt list --upgradeable


## `To search for any specific package`:  

_src_ :  https://www.hostinger.ph/tutorials/how-to-list-installed-packages-on-ubuntu/  
	
	sudo apt list –-installed | grep (PackageName)  

## `to view more information about a specific package, use the following command`:  

	sudo apt packageName

## `Uninstall a package (in DEBIAN)` 
_src_ : https://geniusgeeks.com/uninstall-debian-package/cr
	
	sudo apt-get -–purge remove 'package-name' 

## `Uninstall a package (in UBUNTU)`
_src_ : https://phoenixnap.com/kb/uninstall-packages-programs-ubuntu
	
	sudo apt remove 'package-name'




## `REMOVE app/software`

	sudo apt-get remove <app_name>


## `Install an app in Ubuntu`:

	sudo dpkg -i file.deb

## `Install from a specific directory`:

	sudo dpkg -i file.deb --instdir=destdir 
where `destdir` is your desired installation directory.


## `UBUNTU Add permission to folder CHMOD`

	sudo chown -R $USER:$USER /var/www/
	sudo chown -R <current user> <directory>

more info: https://www.linode.com/docs/guides/modify-file-permissions-with-chmod/ 

or

	sudo chown -v $USER <directory>


## `File permissions in Ubuntu`:

	# ls -l file
	-rw-r--r-- 1 root root 0 Nov 19 23:49 file
	|      ---
	|   ---  |
	|---  |  |
	|  |  |  Other(r--)
	|  |  |	
	|  |  Group(r--)		r = Readable
	|  |					w = Writeable
	|  Owner (rw-)			x = Executable 
	|						- = Denied
	|
	File type

	_________________________
	7	|	rwx		|	111	
	6	|	rw-		|	110
	5	|	r-x		|	101	
	4	|	r--		|	100
	3	|	-wx		|	011
	2	|	-w-		|	010
	1	|	--x		|	001
	0	|	---		|	000

	chmod 400 ------| 4 : owner
					| 0 : group
					| 0 : other 	


## `SSH server`

_src_ : https://www.cyberciti.biz/faq/ubuntu-linux-install-openssh-server/

_set up_ :   
	https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04

	ssh-keygen

	or

	ssh-keygen -b 4096

## Remove a SSH key

	ssh-keygen -f "[path]/.ssh/known_hosts" -R "[ip_address]"





## `Set hostname / check Linux version`

	hostnamectl set-hostname 'name of host'
	check if hostname is changed type in terminal:
		hostname




## `Check OS status/specs`

	lscpu			-	shows detailed info about your CPU
	sudo lshw		-	Provides comprehensive hardware details, including CPU, memory, and network devices.
	lshw -short		-	Presents the output of lshw in a more condensed table format
	cat /etc/os-release		-	Shows the specific name and version of your Ubuntu OS



## `Generate SSH key`

type 'ssh-keygen -b 4096' in host system

	now to copy 'id_rsa' from host system to server (ignore the quotes)
		- scp ~/.ssh/id_rsa.pub server_name@0.0.0.0:[exact_location]

		example:
			scp ~/.ssh/id_rsa.pub coreyms@123.22.22.155:~/.ssh/authorized_keys


OR use ssh-copy-id
The syntax is:
	ssh-copy-id 'username'@'remote_host' 
https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04

Then change the permissions:

	chmod 700 ~/.ssh/
	chmod 600 ~/.ssh/*

	sudo chmod 700 ~/.ssh/
	sudo chmod 600 ~/.ssh/*
	sudo chown -R ${USER} ~/.ssh/
	sudo chgrp -R ${USER} ~/.ssh/



__Note__ : If shows error _"failed to add the host to the list of known host ubuntu ssh"_  
this could be caused by a few things such as:  

-	this could be a Host key mismatch  
	_Solution_ : Remove the old entry for that host from your `~/.ssh/known_hosts` file

		ssh-keygen -R [hostname]@[ip_address]

-	could be a permission issue, The `~/.ssh` directory or the `known_hosts` file may have incorrect permissions, preventing SSH from writing to it.  
	_Solution_	:  Ensure the `~/.ssh` directory and its contents are owned by your user and have appropriate permissions.

		chmod 700 ~/.ssh
        chmod 600 ~/.ssh/known_hosts
	
	You may also need to adjust ownership if it's incorrect:

		sudo chown your_username:your_username ~/.ssh -R



## `VSCODE TYPING SLOW IN UBUNTU`

src: https://askubuntu.com/questions/1051621/why-does-visual-studio-code-work-slow-in-ubuntu

	open VSCODE
	File > Preferences > Settings
	search in terminal:
		Terminal > Integrated> gpu acceleration 
		change Auto to Off



## `REQUIREMENT.TXT - packages having issues in Ubuntu with pip3 install`

	flask-mysqldb 
		work sround:
			sudo apt-get install libmysqlclient-dev

		on windows:
			install it by binary:
			pip install --only-binary :all: mysqlclient





## `DEPLOYING Flask Application on VPS Linux Server using Nginx`

https://medium.com/geekculture/deploying-flask-application-on-vps-linux-server-using-nginx-a1c4f8ff0010  

	gunicorn -w 3 --bind 0.0.0.0:5000 wsgi:app

	the number of workers:
		= 1 cpu x 2 + 1 
		= to know the number of cores a pc has in linux/debian
			nproc --all

https://www.codewithharry.com/blogpost/flask-app-deploy-using-gunicorn-nginx/


**Add desktop environment for ubuntu server**  
https://www.makeuseof.com/install-desktop-environment-gui-ubuntu-server/
s

**Deploy Flask App on VPS**  
https://www.askpython.com/python-modules/flask/deploy-flask-app-on-vps - apache
sudo apt install apache2
sudo apt install libapache2-mod-wsgi-py3


**Deploy with APACHE vid**  
https://www.youtube.com/watch?v=XeVWtpJHZAU&ab_channel=JayHoward

**another vid**  
https://www.youtube.com/watch?v=w0QDAg85Oow&ab_channel=LukePeters


**Deploy in Nginx**  
https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-20-04


**Vid** - Python Flask Tutorial: Deploying Your Application (Option #1) - Deploy to a Linux Server  
https://www.youtube.com/watch?v=goToXTC96Co&list=PL-osiE80TeTs4UjLw5MM6OjgkjFeUxCYH&index=13&ab_channel=CoreySchafer

	29:41 - `pip freeze > requirements.txt` ========================> and move the text into Flask_Blog folder
	30:35 - `scp -r Desktop/Flask_Blog coreyms@45.33.123.214:~/` ===> where we copy Flask_Blog from personal machine to Linode (or any vps)
	31:50 - `sudo apt install python3-pip` 
	32:12 - `sudo apt install python3-venv`
	32:44 - `python3 -m venv Flask_Blog/venv`
	33:19 - `source venv/bin/activate` 	=====================================> in our Flask_Blog dir we activate our venv
	33:50 - `pip install -r requirements.txt` ===============================> we install our pip packages into our venv
	37:40 - `sudo touch /etc/config.json` & `sudo nano /etc/config.json` ====> where we now store our environment variables inside a file instead of the system 
	40:22 - `sudo nano flaskblog/config.py` ===> add the following code 
			`import json`
			`with open('/etc/config.json') as config_file:
			config = json.load(config_file)`
	41:50 - we are still in config.py and replace `os.environ.get` with `config.get`
	43:35 - `export FLASK_APP=run.py` - where we assign the environment variable FLASK_APP to the module
	43:55 - `flask run --host=0.0.0.0` -  we run a local dev server on the linode
	48:26 - `sudo apt install nginx`
	48:53 - `pip install gunicorn`
	50:02 - `sudo rm /etc/nginx/sites-enabled/default` - we remove nginx default config
	50:20 - `sudo nano /etc/nginx/sites-enabled/flaskblog` -  new nginx config solely for our app. Add the code from Corey's snippets. Remember: gunicorn is running on port 8000, nginx is running on port 80
	54:27 - `sudo nano ufw allow http/tcp` &
			`sudo ufw delete allow 5000` &
			`sudo ufw enable` 
	55:00 - `sudo systemctl restart nginx` - restart nginx server
	56:25 - access your URL/static/main.css. This proves that nginx server is serving static content and that it cannot serve the dynamic content because Gunicorn is not running yet.
	58:02 - `nproc --all` - to find out how many cores on this machine
	58:35 - `gunicorn -w 3 run:app` - now that gunicorn is running, we access our main site and this proves that nginx is passing HTTP requests to gunicorn
	1:00:23 - `sudo apt install supervisor` - this software (written in python!) will run Gunicorn in the background
	1:00:50 - `sudo nano /etc/supervisor/conf.d/flaskblog.conf` - create a supervisor config file referring to flaskblog package, and Gunicorn. Add corey's snippets
	1:04:10 - note that we point supervisor to (yet uncreated) log files located:
			`/var/log/flaskblog/flaskblog.err.log` &
			`/var/log/flaskblog/flaskblog.out.log`
	1:05:03 - `sudo mkdir -p /var/log/flaskblog` 
	1:05:22 - `sudo touch /var/log/flaskblog/flaskblog.err.log` &
			`sudo touch /var/log/flaskblog/flaskblog.out.log` - where we now create our log files
	1:05:42 - `sudo supervisorctl reload` - where we restart supervisor
	1:07:40 - `sudo nano /etc/nginx/nginx.conf` - where we access general config file for nginx
	1:07:54 - `client_max_body_size 5M;` - add this code in the config file to increase upload limit from 2MB to 5MB
	1:08:30 - `sudo systemctl restart nginx`

	Supervisor setup  
		.conf file content
		[program:chatup]
		directory=/home/kuryu-chan/Documents/chat_app_linux
		command=/home/kuryu-chan/.local/share/virtualenvs/chat_app_linux-SqBQMYEI/bin/gunicorn -w 17 wsgi:app
		user=kuryu-chan
		autostart=true
		autorestart=true
		stopasgroup=true
		killasgroup=true
		stderr_logfile=/var/log/chat_up/chat_up.err.log
		stdout_logfile=/var/log/chat_up/chat_up.out.log

***Supervisor***  
once new .conf is added - tell supervisor of the new program

	sudo supervisorctl reread
	sudo supervisorctl update


renew SSL every month: setup function to be triggered at intervals automatically  

	sudo crontab -e 
	
format

		* * * * * command to be executed
		| |	| | |
		| |	| | +------------**day of the week** (0-6) (Sunday=0)
		| | | +--------------**Month** (1-12)
		| | +----------------**day of the Month** (1-31)
		| +------------------**hour** (0-23)
		+--------------------**minute** (0-59)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## `TIMERS for scheduled auto restarting of user made services`  
	https://documentation.suse.com/smart/systems-management/html/systemd-working-with-timers/index.html

	view the list of timers
	sudo systemctl list-timers --all | grep <name of timer>


## `Ubuntu shared folder not showing up`:

	- attach shared folder in vbox
	- run guest addition again
	- run this on terminal:  

		sudo apt-get update  
		sudo apt-get install -y build-essential linux-headers-$(uname -r)  
		sudo apt-get install virtualbox-guest-utils  
		sudo adduser $(whoami) vboxsf  
		
	- restart guest for it to take effect  

	if errors in running guess additions, could be errors in the Dynamic Kernel Module Supportt (DKMS)
		
		sudo apt install --reinstall linux-headers-$(uname -r) virtualbox-dkms build-essential




-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## `Create a symbolic link to another folder`:

	sudo ln -s /usr/share/phpmyadmin /var/www/your_domain/phpmyadmin  
	sudo ln -s 1st_location 2nd_location  

another way:  
	To create a symbolic link to a file, open a terminal window and enter the command below:

	ln -s [target] [symlink]

The command consists of the following elements:
-	The -s option instructs ln to create a symlink. With no options specified, the command creates a hard link.  
-	[target] is the file the link references.
-	[symlink] is the location to save the link. If this element is omitted, the command places the symlink in the current working directory.


#### UNLINK the file from the /sites-enabled/ directory:
	
	sudo unlink /etc/nginx/sites-enabled/default

<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ -->

## `NETSTAT commands`

	show active connections:
	sudo netstat -tulpn

*__source__*	:	https://www.tecmint.com/20-netstat-commands-for-linux-network-management/
https://www.geeksforgeeks.org/netstat-command-linux/


<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ -->
## `GENERATE RANDOM HASH`

The secrets module was added in Python 3.6+. It provides cryptographically secure random values with a single call. 
The functions take an optional nbytes argument, default is 32 (bytes * 8 bits = 256-bit tokens). 
MD5 has 128-bit hashes, so provide 16 for "MD5-like" tokens.

	>>> import secrets

	>>> secrets.token_hex(nbytes=16)
	'17adbcf543e851aa9216acc9d7206b96'

	>>> secrets.token_urlsafe(16)
	'X7NYIolv893DXLunTzeTIQ'

	>>> secrets.token_bytes(128 // 8)
	b'\x0b\xdcA\xc0.\x0e\x87\x9b`\x93\\Ev\x1a|u'

	OR

	import random
	import string

	def random_string(length):
		pool = string.letters + string.digits
		return ''.join(random.choice(pool) for i in xrange(length))


<!-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ -->
## `REDIS server`

*__Install on Ubuntu/Debian__*

	>	curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

	>	echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

	>	sudo apt-get update
	>	sudo apt-get install redis

*__Start redis-server__*

if yur having trouble starting:  
	https://stackoverflow.com/questions/42857551/could-not-connect-to-redis-at-127-0-0-16379-connection-refused-with-homebrew

*__Securing Redis__*  
	https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04
	https://redis.io/docs/management/security/


<!-- ------------------------------------------------------------------------------------------------------------------------- -->
## `INSTALL CURL` - cant install curl?

https://stackoverflow.com/questions/22754649/cant-install-pycurl-with-pip

This is a problem indeed. No need to update pip or easy install as it's often advised, 
well it won't hurt to update but you will still have the problem until you :

	install libcurl4-gnutls-dev librtmp-dev packages
	pip install pycurl



_basic CURL install_

	sudo apt install curl
	curl --version
		

<!-- ------------------------------------------------------------ -->
## `CURL Coverter`
https://curlconverter.com/python/

------------------------------------------------------------


## `Install Let's Encrypt SSL on Ubuntu with Apache or Nginx`
https://www.vultr.com/docs/setup-letsencrypt-on-linux/

	--apache: Use the Apache web server
	--nginx: Use the nginx web server
	--redirect: Redirect all HTTP requests to HTTPS.
	-d example.com -d www.example.com: Install a multiple domain (SAN) certificate. You may use up to 100 -d domain entries.
	-m admin@example.com: The notification email address for this certificate.
	--agree-tos: Agree to the terms of service.

	certbot --nginx --redirect -d valkyriesecurityinc.com -d www.valkyriesecurityinc.com -m nomad2@ashgard.com.ph --agree-tos


---------------------------
**NGINX: error 403 permission problems**
>	Causes:
>	-	User is blocked from requesting that page/resource or the site as a whole.
>	-	User tries to access a directory but `autoindex` is set to `off`.
>	-	User tries to access a file that can be only accessed internally.


	To check for ownership and permissions on a path, we can use the namei utility like this -
	$ namei -om /directory
	or 
	ls -l

	sudo chmod -R 755 /directory
	optional:
		sudo chmod -R 664 /directory
	
	more info: https://stackoverflow.com/questions/6795350/nginx-403-forbidden-for-all-files?noredirect=1&lq=1


	403 Error in accessing STATIC files - error is due to Nginx not being in the same user group
	more infor:
	https://stackoverflow.com/questions/16808813/nginx-serve-static-file-and-got-403-forbidden

	Modify nginx.conf
		-	sudo nano /etc/nginx/nginx.conf



<!-- ------------------------------------------------------------------------------------------------------------------------- -->
## `CHMOD persmission codes`

The three digits of the chmod code set permissions for these groups in this order:
-	1. Owner (you)
-	2. Group (a group of other users that you set up)
-	3. World (anyone else browsing around on the file system)

Each digit of this code sets permissions for one of these groups as follows.  
Read is 4. Write is 2. Execute is 1.

	The sums of these numbers give combinations of these permissions:
	0 = no permissions whatsoever; this person cannot read, write, or execute the file
	1 = execute only
	2 = write only
	3 = write and execute (1+2)
	4 = read only
	5 = read and execute (4+1)
	6 = read and write (4+2)
	7 = read and write and execute (4+2+1)


	example:
	chmod 700 apple.txt		-	Only you can read, write to, or execute apple.txt
	chmod 777 apple.txt		-	Everybody can read, write to, or execute apple.txt
	chmod 744 apple.txt		-	Only you can read, write to, or execute apple.txt Everybody can read apple.txt;
	chmod 444 apple.txt		-	You can only read apple.txt, as everyone else.




<!-- ------------------------------------------------------------------------------------------------------------------------- -->
## BOOTING PROBLEMS - initramfs
https://linuxhint.com/fix-initramfs-ubuntu/

1) check the partitions
	df -h 
	or
	blkid

2) file system consistency check - checks filesystem issues & fixes them
	fsk [partitian name (/dev/sdXX)]
	ex: 
		fsk /dev/sdb
		or
		fsk /dev/sdb -y (to disable prompts)

3) type reboot, then type exit - ubuntu will restart afterwards


<!-- ------------------------------------------------------------------------------------------------------------------------- -->
## `UFW - simple firewall` 
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu
	check the status of UFW: 
		sudo ufw status verbose 
		or
		sudo ufw status 

	enable firewall:
		sudo ufw enable

	add applications/ports:	
		sudo ufw allow (app_name)
		ex:
			sudo ufw allow ‘Nginx Full’
	
	add specific port ranges:
		sudo ufw allow (starting port):(ending port)/tcp
		ex: 
			sudo ufw allow 6000:6007/tcp
			sudo ufw allow 6000:6007/udp

	show applications added:
		sudo ufw app list 

	show ports added:
		sudo ufw show added

	show ufw status command has an option to display numbers next to each rule:
		sudo ufw status numbered

	delete rules numbers:
		sudo ufw delete (number_from_numbered)

	delete rules by name:
		sudo ufw delete allow "(name_inclosed_in_double_quotes)"

	reload rules:
		sudo ufw reload


-------------------------------------------------------------------------------------------------------------------------
## `OPENSSL: Encrypt / Decrypt	a string for password`

Encrypt:

	echo 'someTextIWantToEncrypt' | openssl enc -base64 -e -aes-256-cbc -nosalt -pass pass:mySecretPass

Decrypt:

		echo "KPkBkGJ9bs4YHvh24xz7m9jTlYWm1LcIFcWR0DwY4PU=" | openssl enc -base64 -d -aes-256-cbc -nosalt -pass pass:mySecretPass

Command definitions

		-base64			:	The output/input is a base64 string
		-e |-d			:	-e for encryption, -d for decryption
		-aes-256-cbc	:	The encryption/decryption algorhitm
		-salt | -nosalt	:	To add a salt to the encryption/decrpytion and make it more secure
		-pass			:	The password
		-pbkdf2			:	Method to derive a key from the password


-------------------------------------------------------------------------------------------------------------------------
## `TIMEZONE`:
  
modify timzones thru cmd - ubuntu 20.04  
https://www.geeksforgeeks.org/how-to-set-or-change-timezone-on-ubuntu-20-04/

	1) check timezone 
		- timedatectl
			The system’s timezone is also stored in the /etc/timezone file. You can view its contents using.
				- cat /etc/timezone
	2) choose from the list of timezones using:
		- timedatectl list-timezones
	3)set the chosen timezone
		-sudo timedatectl set-timezone <your_time_zone>
		ex:
			sudo timedatectl set-timezone Asia/Manila

***TIME***	:	change time manually
	
	timedatectl set-time <hh:mm:ss>

***DATE***	:	change date manually
	
	timedatectl set-date <yyyy-mm-dd>


-------------------------------------------------------------------------------------------------------------------------
## `Chaning Ports for Apache`

	sudo nano /etc/apache2/ports.conf
	change "Listen 80"
	change the Virtual Host Files:
			sudo nano /etc/apache2/site-available/<domain.conf>
			<VirtualHost *:80>
				ServerAdmin webmaster@localhost
				DocumentRoot /var/www/html
				ErrorLog ${APACHE_LOG_DIR}/error.log
				CustomLog ${APACHE_LOG_DIR}/access.log combined
			</VirtualHost>
	sudo systemctl restart apache2
	sudo systemctl status apache2


-------------------------------------------------------------------------------------------------------------------------
## `Monitor service JOURNALCTL`

To actively follow the logs as they are being written, you can use the ` -f ` flag

	sudo journalctl -u <service> -f


_more info_	:  https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs


<!-- ------------------------------------------------------------------------------------------------------------------------- -->

## `Read files from the terminal`

	cat /var/log/file.txt	->	read the content of short files
	less /var/log/file.txt	->	read the content of long files in an interactive way

to view only a number lines

	head -n <number of lines> /var/log/file.txt		->		view the first few lines of a file
	tail -n <number of lines> /var/log/file.txt		->		view the last few lines of a file	


-------------------------------------------------------------------------------------------------------------------------





