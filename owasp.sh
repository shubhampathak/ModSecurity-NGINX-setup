#!/bin/bash

##########################################################################################
# OWASP TOP-10 CRS Setup Script															 #
# Reference:																			 #	
# https://raw.githubusercontent.com/SpiderLabs/owasp-modsecurity-crs/v3.0/master/INSTALL #
##########################################################################################

c='\e[32m' # Coloured echo (Green)
r='tput sgr0' #Reset colour after echo

if [[ $EUID -ne 0 ]]; then
   	echo -e "${c}Must be run as root, add \"sudo\" before script"; $r
   	exit 1
else
	echo -e "${c} Setting up OWASP Top-10 official Core Rule Set (CRS)"; $r
	cd /etc/nginx/modsec
	git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git
	cd owasp-modsecurity-crs
	# Please take time to go through these
    # files and customize the settings for your environment. Failure to
    # do so may result in false negatives and false positives.
	cp crs-setup.conf.example crs-setup.conf
	cp rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
	cp rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
	echo -e "# OWASP Top 10 rules from https://github.com/SpiderLabs/owasp-modsecurity-crs.git into /etc/nginx/modsec/owasp-modsecurity-crs\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/crs-setup.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-901-INITIALIZATION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-905-COMMON-EXCEPTIONS.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-910-IP-REPUTATION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-911-METHOD-ENFORCEMENT.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-912-DOS-PROTECTION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-913-SCANNER-DETECTION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-921-PROTOCOL-ATTACK.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-950-DATA-LEAKAGES.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-959-BLOCKING-EVALUATION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-980-CORRELATION.conf\"\nInclude \"/etc/nginx/modsec/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf\"\n# Basic test rule\n# SecRule ARGS:testparam \"@contains test" "id:1234,deny,status:403\"" >> /etc/nginx/modsec/main.conf
	(set -x; nginx -t)
	service nginx restart
fi	
