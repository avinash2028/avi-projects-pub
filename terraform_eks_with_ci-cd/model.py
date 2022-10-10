import mysql.connector
from config import get_db_details
#establishing the connection
db_obj = get_db_details()
conn = mysql.connector.connect(
   user=db_obj['DB_USER'], password=db_obj['DB_PASSWORD'], host=db_obj['DB_HOST'], database='mysql'
)

#Creating a cursor object using the cursor() method
cursor = conn.cursor()

# create database
dbsql = "CREATE DATABASE IF NOT EXISTS appdb"
cursor.execute(dbsql)
#Dropping EMPLOYEE table if already exists.
cursor.execute("use appdb")
cursor.execute("DROP TABLE IF EXISTS EMPLOYEE")

#Creating table as per requirement
sql ='''CREATE TABLE EMPLOYEE(
   id INT AUTO_INCREMENT,
   email_id CHAR(20) NOT NULL UNIQUE,
   name CHAR(20),
   age INT,
   sex CHAR(1),
   income FLOAT,
   Primary key(id)
)'''
cursor.execute(sql)

#Closing the connection
conn.close()