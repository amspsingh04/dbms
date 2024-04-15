from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
CORS(app)  
app.config['MYSQL_HOST'] = 'localhost' 
app.config['MYSQL_USER'] = 'amspsingh04'
app.config['MYSQL_PASSWORD'] = 'pass'
app.config['MYSQL_DB'] = 'db'

@app.route('/')
def hello():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run()
    CORS(app)