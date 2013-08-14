[root@ip-10-130-91-109 sysinfo]# python sysinfo.py -h
usage: sysinfo.py [options]

options:
  -h, --help  show this help message and exit
  --nojmap    collect system info statistics without jmap dump
  --ftp=FTP   FTP information should be in format host:user:passwd


[root@ip-10-130-91-109 sysinfo]# python sysinfo.py --nojmap --ftp=ftp.apigee.com:sysinfo:A9fN@ngh10
zip file create with name ip-10-130-91-109_sysinfo_2013_7_30_10_33_4.zip
zip file successfully uploaded to host: ftp.apigee.com  
  
