
#!/bin/bash
usage ()
{

        echo "create_wrapper_cookbook.sh -h <hostname > -d <domain> -c <country> -s <state> -u <use> -p -n"
        echo "-h HOSTNAME "
        echo "-d Domain = BCC / APAC / DMZ - default is BCC"
        echo "-c Country = AU / SG / HK / JP"
        echo "-s State = PROD / UAT / DEV - default is PROD"
        echo "-u Use = CLR (Clearing) / GES / SSV (Shared Services) - default is CLR"
        echo "-p Server is Physical - default is VIRTUAL"
        echo "-n NFS Client - default is NOT NFS (cannot be used if the domain = DMZ)"

}

options=':h:d:c:s:u:pnta'
while getopts $options option
do
    case $option in
        h) HOSTNAME=$OPTARG;; 
        d) DOMAIN=$OPTARG;;
        c) COUNTRY=$OPTARG;;
        s) STATE=$OPTARG;;
        u) USE=$OPTARG;;
        p) PORV=1;;
        n) NFS=1;;
        t) DEBUG=1;;
        a) UPDATE=1;;
        \?) usage; exit 1;;
    esac
done

# Sanity check the command line arguments
if [ $OPTIND -eq 1 ]; then
        usage; exit 1
fi



cd /root/chef-repo/cookbooks/wrappers_cookbooks
cp -pr wc_template.bcc.ap.abn wc_$HOSTNAME.bcc.ap.abn
cd wc_$HOSTNAME.bcc.ap.abn
grep -r HKVLAPAACfixco *|awk -F":" '{print $1}'| xargs sed -i "s/HKVLAPAACfixco/$HOSTNAME/g"

FILE="recipes/default.rb"

/bin/cat <<EOM >$FILE
#
# Cookbook Name:: wc_$HOSTNAME.bcc.ap.abn
# Recipe:: override
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

node.override['Country'] = '$COUNTRY'
node.override['Domain'] = '$DOMAIN'
node.override['Use'] = '$USE'
node.override['State'] = '$STATE'

include_recipe "aac_linux_baseline"

EOM
