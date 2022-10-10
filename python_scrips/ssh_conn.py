ssh_conn.py 
import paramiko
import os
disk_space = []
mem_space = []
def ssh_conn_pri(pri_ip):
    temp = []
    k = paramiko.RSAKey.from_private_key_file("/var/key.pem")
    c = paramiko.SSHClient()
    c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
#    print ("connecting")
#    print('ssh conection', pri_ip)
    c.connect( hostname = pri_ip, username = "ubuntu", pkey = k )
    #
#    print ("connected")
    commands = [ "sudo df -h | grep /dev/xv",
                "sudo free -m",
                "sudo uptime"
                    ]
    for command in commands:
        print ("Executing {}".format( command ))
        stdin , stdout, stderr = c.exec_command(command)
        print(stdout.read().decode('ascii').strip("\n"))
        #for i in stdout.read().split():
        #    if i.isdigit():
        #    temp.append(i)
        #print(temp)

#        print( "Errors")
        #print (stderr.read())
    c.close()

def main():
    ssh_conn(pri_ip)
#    ssh_conn_pri('10.0.2.57')
if __name__ == "__main__":#
    main()

