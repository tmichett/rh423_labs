echo verifying that CA certificate does not already exist
echo ""
if 
	certutil -d /home/student/cacerts -f /home/student/ca_nss_passwd -K 2> /dev/null | grep -q rh423CA 
then 
	echo rh423CA appears to exist. If you really want to recreate, delete the cacerts directory and then run this script.
	exit
fi

echo creating the directory to hold the NSS database
echo ""
mkdir /home/student/cacerts

echo populating the password file 
echo ""
echo "redhat123" > /home/student/ca_nss_passwd

echo initializing the database 
echo ""
# This will stop and prompt for new pass if already done
certutil -d /home/student/cacerts -f /home/student/ca_nss_passwd -N

echo creating the rh423CA certificate
echo ""
echo "y\n0\ny" | certutil -S -s "CN=RH423 CA" -n rh423CA -x -v 120 -t "TC,," --keyUsage certSigning -z /var/log/lastlog -2 -m 1234 -d /home/student/cacerts/ -f /home/student/ca_nss_passwd

echo ""
echo extracting the rh423CA certificate to /tmp/rh423-ca.crt
echo ""
certutil -d /home/student/cacerts/ -f /home/student/ca_nss_passwd -L -n rh423CA -a > /tmp/rh423-ca.crt

echo finished

