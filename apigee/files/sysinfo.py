#!/usr/bin/python

import os
import sys
import subprocess
from datetime import datetime
import urllib2
import optparse
import zipfile
from ftplib import FTP

os_info_map = {}
java_info_map = {}
server_metric_map = {}

'''
Not using json module here because its introduced in 2.6 and might not be available on all machines
TODO: change this code to use json module once its verified that all machines have that module
'''
def get_UUID_and_IP():
    try:
        URL =   "http://localhost:8080/v1/servers/self"
        resp = urllib2.urlopen(URL)
        json =  resp.read()
    except:
        return 'Error, not able to get UUID from runtime metrics', 'Error, not able to get IP from runtime metrics'
        
    arr =  json.split(',')
    uuid_str =  arr[len(arr)-1]
    ip_str = arr[1]
    uuid = uuid_str.split(':')[1] 
    ip = ip_str.split(':')[1]
    return uuid, ip

def sanitize(comp):
    comp = comp.replace('[','')
    comp = comp.replace(']','')
    comp = comp.replace('"','')
    comp = comp.strip()
    return comp

def collect_server_metrics():
    try:
        URL =   "http://localhost:8080/v1/runtime/metrics"
        resp = urllib2.urlopen(URL)
        metrices = resp.read() 
    except:
        server_metric_map['Error'] = 'Not able to collect server metrics, failed to call: %s' % URL
        return

    arr = metrices.split(',')
    for comp in arr:
        try:
            comp = sanitize(comp)        
            sub_url =  '%s/%s' % (URL, comp)
            resp = urllib2.urlopen(sub_url)
            json = resp.read()
            server_metric_map[comp] = json
        except:
            server_metric_map[comp + '_Error'] = 'Not able to collect server metrics for %s, failed to call: %s' % (comp,sub_url)            

def get_pid():
    proc = subprocess.Popen("ps -ef | grep apigee-1.0.0 | grep -v 'grep apigee-1.0.0' | grep -v 'sh' | awk '{print$2}'", stdout=subprocess.PIPE, stderr=None, shell=True)
    output = proc.communicate()[0]
    return output

def collect_os_info():
    global os_info_map
    
    #ulimit
    proc = subprocess.Popen("ulimit -a", stdout=subprocess.PIPE, stderr=None, shell=True)
    output = proc.communicate()[0]
    os_info_map['ulimit'] = output

    #vmstat
    proc = subprocess.Popen(['vmstat', '-s'], stdout=subprocess.PIPE, stderr=None, shell=False)
    output = proc.communicate()[0]
    os_info_map['vmstat'] = output

    #lsof
    proc = subprocess.Popen(['lsof', '-i', 'tcp'], stdout=subprocess.PIPE, stderr=None, shell=False)
    output = proc.communicate()[0]
    os_info_map['lsof'] = output

    #netstat
    proc = subprocess.Popen(['netstat', '-pl'], stdout=subprocess.PIPE, stderr=None, shell=False)
    output = proc.communicate()[0]
    os_info_map['netstat'] = output

def collect_java_info(pid, folder_name, doJmap):
    global java_info_map
    cmd = '$JAVA_HOME/bin/jstack %s' % pid
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=None, shell=True)
    output = proc.communicate()[0]
    java_info_map['jstack'] = output

    cmd = '$JAVA_HOME/bin/jmap -histo %s' % pid
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=None, shell=True)
    output = proc.communicate()[0]
    java_info_map['jmap'] = output

    if doJmap:
        cmd = "$JAVA_HOME/bin/jmap -dump:format=b,file=%s/heap_dump.hprof %s" % (folder_name, pid)
        subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=None, shell=True)


def log(folder_name, pid):
    os.makedirs(folder_name)
    write_os_info(folder_name)
    write_java_info(folder_name, pid)
    write_server_metric(folder_name)


def write_os_info(folder_name):
    global os_info_map
    f =  open(folder_name+'/os_info.txt' , 'w')
    write(f, os_info_map)

    
def write_java_info(folder_name, pid):
    global java_info_map
    f =  open(folder_name+'/java_info.txt' , 'w')
    write_kv(f,"PID",pid)
    write(f, java_info_map)

def write_server_metric(folder_name):
    global server_metric_map
    f =  open(folder_name + '/server_metric.txt' , 'w')
    uuid, ip = get_UUID_and_IP()
    write_kv(f,"UUID", uuid)
    write_kv(f,"IP",ip)
    write(f, server_metric_map)    


def write(f, info_map):
    try:
        for k,v in info_map.iteritems():
            write_kv(f,k,v)
    finally:
        f.close()    

def write_kv(f,k,v):
    f.write(k)
    f.write('\n')
    f.write('------------')
    f.write('\n')
    f.write(v)
    f.write('\n\n') 

def get_hostname():
    return os.uname()[1]

def compress(folder_name):
    host = get_hostname()
    zip_file = '%s_%s.zip' % (host, folder_name)
    zf = zipfile.ZipFile(zip_file, mode='w')
    try:
        for root, _, files in os.walk('./%s' % folder_name):
            for f in files:
                if not f.startswith('.'):
                    zf.write(os.path.join(root, f))
        print 'zip file create with name %s' % zip_file
        return zip_file
    finally:
        zf.close()

def ftp_upload(ftp_info, folder_name):
    upload_file = None
    ftp = None
    try:
        zip_file = compress(folder_name)
        host, user, passwd = ftp_server_info(ftp_info)
        ftp = FTP(host)
        ftp.login(user, passwd)
        upload_file = open(zip_file, 'rb') 
        ftp.storbinary('STOR ' + zip_file, upload_file)
        print 'zip file successfully uploaded to host: %s' % host
    finally:
        if upload_file:
            upload_file.close()
        if ftp:
            ftp.quit()


def ftp_server_info(ftp_info):
    ftp_info = ftp_info.split(':')
    return ftp_info[0], ftp_info[1], ftp_info[2] 

'''
using optparse insted of argparse because not sure if prod machines are having 2.7.5
'''
def parse_args():
    parser = optparse.OptionParser()
    parser.add_option('--nojmap', action="store_true", default=False, dest="noJmap", help='collect system info statistics without jmap dump')
    parser.add_option('--ftp', action="store", default=None, dest="ftp", help='FTP information should be in format host:user:passwd')
    (options, args) = parser.parse_args()
    if options.ftp:
        ftp_info = options.ftp.split(':')
        if len(ftp_info) < 3:
            parser.error('FTP info should be in format host:user:passwd')
    return options

def main():
    options = parse_args()
    dtime = datetime.now()
    
    folder_name = 'sysinfo_%s_%s_%s_%s_%s_%s' % (dtime.year, dtime.month, dtime.day, dtime.hour, dtime.minute, dtime.second)
    pid = get_pid()
    
    collect_os_info()
    collect_java_info(pid, folder_name, not options.noJmap)
    collect_server_metrics()
    log(folder_name, pid)
    
    if options.ftp:
        ftp_upload(options.ftp, folder_name)

    

if __name__ == '__main__':
    main()
    