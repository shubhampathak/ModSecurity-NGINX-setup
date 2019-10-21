#!/bin/bash

#####################################################################################################
# ModSecurity Web Application Firewall v3 Installation and OWASP Top-10 Rule Setup script (complete)#
#####################################################################################################

c='\e[32m' # Coloured echo (Green)
r='tput sgr0' #Reset colour after echo

if [[ $EUID -ne 0 ]]; then
   	echo -e "${c}Must be run as root, add \"sudo\" before script"; $r
   	exit 1
else

	#Latest stable NGINX (important)
	echo -e "${c}Adding Latest Stable NGINX PPA from launchpad.net"; $r
	sudo add-apt-repository ppa:nginx/stable -y
	apt-get update -y
	apt-get install -y nginx
	apt-get upgrade -y

	echo -e "${c}Checking NGINX version"; $r
	(set -x; nginx -v )
	service nginx restart

	#Required Dependencies Installation
	echo -e "${c}Installing Prerequisites"; $r
	apt-get install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev
    
    #ModSecurity Installation
    echo -e "${c}Installing and setting up ModSecurity"; $r
    cd
    git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity
    cd ModSecurity
    git submodule init
    git submodule update
    ./build.sh
    ./configure
    make
    make install
    cd ..
    rm -rf ModSecurity
    
    #ModSecurity NGINX Conector Module Installation
    echo -e "${c}Downloading nginx connector for ModSecurity Module"; $r
    cd
    git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
    
    #Filter nginx version number only
    nginxvnumber=$(nginx -v 2>&1 | grep -o '[0-9.]*$')
    echo -e "${c} Current version of nginx is: " $nginxvnumber; $r
    wget http://nginx.org/download/nginx-"$nginxvnumber".tar.gz
    tar zxvf nginx-"$nginxvnumber".tar.gz
    rm -rf nginx-"$nginxvnumber".tar.gz
    cd nginx-"$nginxvnumber"
    ./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
    make modules

    #Adding ModSecurity Module
    mkdir /etc/nginx/additional_modules
    cp objs/ngx_http_modsecurity_module.so /etc/nginx/additional_modules
    sed -i -e '5iload_module /etc/nginx/additional_modules/ngx_http_modsecurity_module.so;\' /etc/nginx/nginx.conf
    (set -x; nginx -t)
    service nginx restart


    #Enabling ModSecurity
    mkdir /etc/nginx/modsec
    wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
    wget -P /etc/nginx/modsec/ https://github.com/SpiderLabs/ModSecurity/blob/49495f1925a14f74f93cb0ef01172e5abc3e4c55/unicode.mapping
    mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf

    #Change SecRule from Detection Only to ON (Important)
    sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf

    #making main.conf in /etc/nginx/modsec
    echo -e "# From https://github.com/SpiderLabs/ModSecurity/blob/master/\n# modsecurity.conf-recommended\n#\n# Edit to set SecRuleEngine On\nInclude \"/etc/nginx/modsec/modsecurity.conf\"" > /etc/nginx/modsec/main.conf
fi	

