#!/bin/bash
cache_server() {
            for i in FOOTER HREF_CATEGORY_DATA HEADER
            do
                ssh -t cache@10.0.0.30 "curl -v http://api.internal.com/internal/v1/cache/clean/$i"
            done
            }
cache_akamai() {
           #cd /opt/script/akamai
           source /root/akamai/bin/activate
           cache_array=("left/nav" "left/nav" "left" "left/nav" "header" "footer" )
           for ((i=0;i<${#cache_array[@]};i++))
           do
             http --auth-type edgegrid -a ccu: :/ccu/v3/invalidate/url/production objects:='["https://api.example.com/v1/menu/${cache_array[i]}"]'
           done
           deactivate
           }
######
cache_server
cache_akamai $@








####
# setup akamai

pip install 

asn1crypto==0.24.0
certifi==2019.6.16
cffi==1.12.3
chardet==3.0.4
cryptography==2.7
edgegrid-python==1.1.1
httpie==1.0.2
httpie-edgegrid==1.0.6
idna==2.8
ndg-httpsclient==0.5.1
pyasn1==0.4.5
pycparser==2.19
Pygments==2.3.1
pyOpenSSL==19.0.0
requests==2.21.0
six==1.12.0
urllib3==1.21.1




