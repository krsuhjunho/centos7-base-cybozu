#!/bin/bash
#VAR
USER_APACHE="apache"
CYBOZU_VER="10.8.5"
CYBOZU_FILE_URL="https://download.cybozu.co.jp/office10/cbof-${CYBOZU_VER}-linux.bin"
#PATH
SRC_PATH="/usr/local/src/"
APACHE_PATH="/var/www"
CGI_PATH="${APACHE_PATH}/cgi-bin"
HTML_PATH="${APACHE_PATH}/html"
CYBOZU_DATA_PATH="/var/local/cybozu/office/cbag/cb5"


ECHO_MESSAGE()
{
echo ""
echo "##########${1}###########"
echo ""
}

####################	CYBOZU INSTALL	###################
CYBOZU_INSTALL()
{
ECHO_MESSAGE "CYBOZU INSTALL START"
ECHO_MESSAGE "CYBOZU VER => ${CYBOZU_VER}"


#Download File
cd ${APACHE_PATH}
wget https://download.cybozu.co.jp/office10/cbof-${CYBOZU_VER}-linux.bin 
bash "cbof-${CYBOZU_VER}-linux.bin"
}



####################	MAIN SHELL START	###################
MAIN()
{
CYBOZU_INSTALL
}

MAIN