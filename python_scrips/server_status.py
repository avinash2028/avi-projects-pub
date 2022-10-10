server_status.py
import boto3
import os
import csv
import time
import pdb
import base64
import paramiko
from config import AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
import ssh_conn
tag_name = [
    "MWEB-server",
    "wwwexample-AutoScale",
    "auth-service",
    "courier-service",
    "engine-auto",

]
class color:
   PURPLE = '\033[95m'
   CYAN = '\033[96m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[94m'
   GREEN = '\033[92m'
   YELLOW = '\033[93m'
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'

class Server_Status:
    def __init__(self):
        self.conn_aws()
        self.Pri_ip()

    def conn_aws(self):
        self.client = boto3.client(
            'ec2',
            aws_access_key_id=AWS_ACCESS_KEY_ID,
            aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
            region_name=AWS_DEFAULT_REGION

        )



    def Pri_ip(self):
        for server_name in tag_name:

            des_res = self.client.describe_instances(Filters=[{'Name':'tag:Name', 'Values':[server_name,]}])
            for ind in range(len(des_res['Reservations'])):
                private_ip = des_res['Reservations'][ind]['Instances'][0]['PrivateIpAddress']
                print('################################################################')
                print('#', server_name, '-----------------------------', private_ip, '#')
                print('################################################################')
                ssh_conn.ssh_conn_pri(private_ip)
                print('--------------------------------------------------------------')
                #pdb.set_trace()


Server_Status()

