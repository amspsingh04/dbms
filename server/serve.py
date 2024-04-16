from flask import Flask, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

DATABASE = {
    'database': 'dbms_proj',
    'user': 'spsin',
    'password': 's1p2s3p4',
    'host': 'localhost',
    'port': '5432',
}

def get_db_connection():
    conn = psycopg2.connect(**DATABASE)
    return conn

@app.route('/students', methods=['GET'])
def get_students():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM student;')
    students = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(students)

if __name__ == '__main__':
    app.run(debug=True)
