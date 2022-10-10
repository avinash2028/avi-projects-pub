import sys

import time

import csv

import urllib

import parse

from pymongo import MongoClient



host = ''

user = ''

passwd = ''

def mongo_insert():

    with open("email_id.csv", 'r') as csvfile:

        reader = csv.DictReader(csvfile)

        for row in reader:

            var = dict(row)

            email_id = row.get('email')

            block = row.get('isCodBloacked')

            username = urllib.parse.quote_plus(user)

            password = urllib.parse.quote_plus(passwd)

            myclient = MongoClient('mongodb://%s:%s@%s' % (username, password, host))



            mydb = myclient["jarvis"]

            mycol = mydb["blocked_user"]

            mydict = {"emailId": email_id, "isCodBloacked": block}



            x = mycol.insert_one(mydict)

            print(x)





mongo_insert()
