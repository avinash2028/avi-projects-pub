from flask import Flask, request, json
from flask_mysqldb import MySQL
import MySQLdb.cursors
from config import get_db_details
app = Flask(__name__)  
db_obj = get_db_details()
app.config['MYSQL_HOST'] = db_obj['DB_HOST']
app.config['MYSQL_USER'] = db_obj['DB_USER']
app.config['MYSQL_PASSWORD'] = db_obj['DB_PASSWORD']
app.config['MYSQL_DB'] = 'appdb'

mysql = MySQL(app)
@app.route('/emp_form', methods=['POST'])
def put_info():
    data = json.loads(request.data)
    try:
        if 'email_id' and 'name' in data:
            email_id    = data['email_id']
            name        = data['name']
            sex         = data['sex']
            income      = data['income']
            age         = data['age']
            cur = mysql.connection.cursor()
            cur.execute("INSERT INTO EMPLOYEE(email_id, name, age, sex, income) VALUES (%s, %s, %s, %s, %s)", (email_id, name, age, sex, income))

            mysql.connection.commit()
            cur.close()
            return "success"
        
        else:
            return "email_id and name mandatory field"
    except Exception as e:
        return "email_id already exist"


@app.route('/emp_info', methods=['GET'])
def get_info():
    data = json.loads(request.data)
    try:
       if 'email_id' in data:
           email_id    = data['email_id']
           print(email_id)
           cur = mysql.connection.cursor()
           cur.execute("SELECT * FROM EMPLOYEE WHERE email_id = '{}'".format(email_id))
           emp_info = cur.fetchall()
           print(emp_info)
           cur.close()
           return json.dumps(emp_info)
       else:
            return "email_id is mandatory field"
    except Exception as e:
        return "email_id does not exist"

    
   
if __name__ == '__main__':  
   app.run(debug = True, host='0.0.0.0')  