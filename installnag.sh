
			NAGIOS INSTALL AND CONFIGURATION THROUGH YUM IN CENTOS 7

SERVER SIDE :-
Step 1 :-  
#yum install httpd
Step 2 :-	
#vim /etc/yum.repos.d/rpmfind.repo

# Rpmfind repository file

[rpmfind]
name=Rpmfind repository
baseurl=ftp://195.220.108.108/linux/epel/7/x86_64/
enabled=1
gpgcheck=0

Step 3 :-

# yum install nagios nagios-common nagios-plugins-all

Step 4 :-

# htpasswd -c /etc/nagios/passwd nagiosadmin

Step 5 :-

#vim /etc/sysconfig/selinux

Selinux=disabled

#setenforce 0

Step 6 :-

#firewall-cmd -–permanent -–add-port=80/tcp
#firewall-cmd -–permanent -–add-port=8041/tcp
#firewall-cmd -–reload

Step 7 :-

#systemctl restart nagios
#systemctl restart httpd

Step 8 :-

http://<serverip>/nagios/

Step 9 :-

#vim /etc/nagios/objects/localhost.cfg

:%s/localhost/<serverhostname>/g
:%s/127.0.0.1/<serveripaddress>/g

Step 10 :-

#systemctl restart nagios
#systemctl trestart httpd

http://<serverip>/nagios/

CLIENT SIDE :-

Step 1:-

#yum install nrpe

#yum install nagios-plugins-* 

Step 2 :-

#vim /etc/nagios/nrpe.cfg

Allow_host=<server ipaddress>

Step 3 :-

#firewall-cmd --permanent -–add-port=5666/tcp
#firewall-cmd -–reload
#vim /etc/services

nrpe	5666	#NRPE

SERVER SIDE :-

Step 11 :-

#vim /etc/nagios/nagios.cfg

cfg_dir=/etc/nagios/servers(uncoomit This line)

Step 12 :-

#cd /etc/nagios/

#mkdir servers

#cd servers

#vim server.cfg

define host{
        use                     linux-server            ; Name of host template to use
                                                        ; This host definition will inherit all variables that are defined
                                                        ; in (or inherited by) the linux-server host template definition.
        host_name               <client Hostname>
        alias                   <client Hostname>
        address                 <client Ipaddress>
        }

Step 13 :-

#nagios –v /etc/nagios/nagios.cfg

#systemctl restart nagios

#systemctl restart httpd

http://<serverip>/nagios/

Step 14 :-

#vim /etc/nagios/nagios.cfg

cfg_dir=/etc/nagios/services(added this line)

#cd /etc/nagios

#mkdir services

#cd services

#vim service.cfg

define service{
use                     		generic-service ; Name of service template to use
host_name               		<Client Hostname>
service_description     		Current Load
check_command           check_nrpe!check_load
}

define service{
use                     		generic-service ; Name of service template to use
host_name               		<Client Hostname>
service_description     		Current Users
check_command           		check_nrpe!check_users
}
define service{
use                     		generic-service ; Name of service template to use
host_name              		 <Client Hostname>
service_description     		Chek Disk
check_command           		check_nrpe!check_hda1
}
define service{
use                     		generic-service ; Name of service template to use
host_name               		<Client Hostname>
service_description     		Zombie Procs
check_command           		check_nrpe!check__zombie_procs
}
define service{
use                    			 generic-service ; Name of service template to use
host_name              		 <Client Hostname>
service_description    		 Total Processes
check_command           		check_nrpe!check_total_procs
}






Step 15 :-	

#vim /etc/nagios/objects/commands.cfg
define command{
        command_name    check_nrpe
        command_line    /usr/lib64/nagios/plugins/check_nrpe -H $HOSTADDRESS$
        }
#nagios –v /etc/nagios/nagios.cfg
<Display The Nrpe Error Go to client Side>

CLIENT SIDE :-

Step 4 :-
#scp –r /usr/lib64/nagios/plugins/check_nrpe root@<Server Ipaddres>:/usr/lib64/nagios/plugins/

SERVER SIDE :-

Step 16 :-
#nagios –v /etc/nagios/nagios.cfg
#systemctl restart nagios
#systemctl restart httpd
http://<serveripaddress>/nagios

SERVER SIDE :-

READ ONIY USER :-

#vim /etc/nagios/cgi.cfg
authorized_for_read_only=readonly (Uncommit This Line)
authorized_for_all_services=nagiosadmin,readonly
authorized_for_all_hosts=nagiosadmin,readonly
# htpasswd  /etc/nagios/passwd readonly

#systemctl restart nagios
#systemctl restart httpd

ADDED PLUGINS(MYSQL, SSH, FTP ,HTTP,DHCP) :-

CLIENT SIDE :-

#vim /etc/nagios/nrpe.cfg

command[check_mysql]=/usr/lib64/nagios/plugins/check_mysql -w 5 -c 10
command[check_ssh]=/usr/lib64/nagios/plugins/check_ssh -w 5 -c 10
command[check_ftp]=/usr/lib64/nagios/plugins/check_ftp -w 5 -c 10
command[check_dhcp]=/usr/lib64/nagios/plugins/check_dhcp -w 5 -c 10
command[check_http]=/usr/lib64/nagios/plugins/check_http -w 5 -c 10
#systemctl restart nrpe
SERVER SIDE :-

(MYSQL)
#vim /etc/nagios/object/commands.cfg
# 'check_mysql' command definition
define command{
        command_name    check_mysql
        command_line    $USER1$/check_mysql $ARG1$
        }
#vim /etc/nagios/services/services.cfg
define service{
use                     		generic-service ; Name of service template to use
host_name              	 <Client Hostname>
service_description     	MYSQL
check_command           	check_nrpe!check_mysql
}
define service{
use                    		 generic-service ; Name of service template to use
host_name               	<Client Hostname>
service_description     	SSH
check_command           	check_nrpe!check_ssh
}
define service{
use                     		generic-service ; Name of service template to use
host_name               	<Client Hostname>
service_description     	FTP
check_command          	 check_nrpe!check_ftp
}
define service{
use                     		generic-service ; Name of service template to use
host_name               	<Client Hostname>
service_description    	 DHCP
check_command         	  check_nrpe!check_dhcp
}
define service{
use                     		generic-service ; Name of service template to use
host_name               	<Client Hostname>
service_description     	HTTP
check_command           	check_nrpe!check_http
}

HOSTGROUPS :-

SERVER SIDE :-	
#vim /etc/nagios/nagios.cfg
cfg_file=/etc/nagios/hostgroup.cfg
#cd /etc/nagios
#vim hostgroup.cfg
define hostgroup {
hostgroup_name  		Linux-servers
alias           		Servers
members         		<Server Hostname>, <Client Hostname>,
}


Integrating SMTP with POSTFIX

=> Login to the machine.
=> #cd /etc/postfix
=> #cp -avf main.cf main.cf_bak-`date +%Y%m%d`
=> vim main.cfg

====Add below lines at the bottom of the file ====

relayhost = mail.itblabs.com:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
#smtp_tls_CAfile = /etc/postfix/cacert.pem
#smtp_use_tls = yes

=> #touch /etc/postfix/sasl_passwd

=> # vim /etc/postfix/sasl_passwd

====Add authentication ======

mail.itblabs.com:587    nagiosadmin@itblabs.com:itblabs@1234


=> 

#chmod 400 /etc/postfix/sasl_passwd

#postmap /etc/postfix/sasl_passwd


#systemctl reload postfix 


Test it and verify it if you are able to sending the email.

echo "Test mail from Linux server" | mail -s "Test mail" -r nagiosadmin@itblabs.com  prabhakar.a@itblabs.com

#vim /etc/nagios/objects/commands.cfg

 define command {

    command_name    notify-host-by-email
    command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" -r nagiosadmin@itblabs.com $CONTACTEMAIL$
}



define command {

    command_name    notify-service-by-email
    command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | /usr/bin/mail -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" -r nagiosadmin@itblabs.com $CONTACTEMAIL$
}
 

#vim /etc/nagios/objects/contacts.cfg

define contact {

    contact_name            nagiosadmin             ; Short name of user
    use                     generic-contact         ; Inherit default values from generic-contact template (defined above)
    alias                   Nagios Admin            ; Full name of user
    email                   nagiosadmin@itblabs.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******
}



