# ModSecurity-NGINX-Setup + OWASP CRS Setup

Bash scripts to automatically install and setup ModSecurity WAF to work with NGINX and add OWASP Core Rule Set (CRS).

**Based on**: [ModSecurity v3](https://github.com/SpiderLabs/ModSecurity) (libmodsecurity)

## Compatibility

Tested against Ubuntu 16.04 & 18.04, but it should work with other Ubuntu distributions as well.
Server: NGINX

## setup.sh

Setup script will:

1. Grab latest stable release of NGINX (PPA).
2. Install prerequisites for ModSecurity.
3. Setup ModSecurity-nginx connector based on current nginx version.
4. Enable ModSecurity Module and add configuration files.

## owasp.sh

After running setup script, run this to automatically add OWASP Core Rule Set.

Reference: [https://raw.githubusercontent.com/SpiderLabs/owasp-modsecurity-crs/v3.0/master/INSTALL](https://raw.githubusercontent.com/SpiderLabs/owasp-modsecurity-crs/v3.0/master/INSTALL)

## update.sh

To do.

## Usage

```shell
chmod +x setup.sh owasp.sh
sudo ./setup.sh
sudo ./owasp.sh
```

## To Enable:

After installing these scripts:

```shell
nano /etc/nginx/<your_nginx_conf_file_location>
```

Turn on `modsecurity` and `modsecurity_rules_file` by adding this to your nginx conf file:

```shell
modsecurity on;
modsecurity_rules_file /etc/nginx/modsec/main.conf;
```

**Example:**

```shell
server {
    # ...
    modsecurity on;
    modsecurity_rules_file /etc/nginx/modsec/main.conf;
}
```

