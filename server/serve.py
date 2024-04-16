from flask import Flask, jsonify, render_template
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True

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

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/students', methods=['GET'])
def get_students():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM student;')
    students = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(students)
@app.route('/books', methods=['GET'])
def get_books():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM book;')
    books = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(books)

@app.route('/courses', methods=['GET'])
def get_courses():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM course;')
    courses = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(courses)

@app.route('/faculty', methods=['GET'])
def get_faculty():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM faculty;')
    faculty_members = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(faculty_members)

@app.route('/menu', methods=['GET'])
def get_menu():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM menu;')
    menu_items = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(menu_items)

@app.route('/mess', methods=['GET'])
def get_mess():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM mess;')
    mess_details = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(mess_details)

@app.route('/hostels', methods=['GET'])
def get_hostels():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM hostel;')
    hostels = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(hostels)

@app.route('/maintenance', methods=['GET'])
def get_maintenance_requests():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM maintenance;')
    maintenance_requests = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(maintenance_requests)

@app.route('/borrow', methods=['GET'])
def get_borrow():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM borrow;')
    borrow_records = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(borrow_records)

@app.route('/enrollments', methods=['GET'])
def get_enrollments():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM enrollment;')
    enrollments = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(enrollments)

if __name__ == '__main__':
    app.run(debug=True)

