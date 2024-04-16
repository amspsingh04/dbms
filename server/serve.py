from flask import Flask, abort, jsonify, render_template, request
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

def add_data(table_name, fields, values):
    query = f"INSERT INTO {table_name} VALUES ({', '.join(['%s'] * len(fields))});"
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(query, values)
        conn.commit()
    except psycopg2.IntegrityError as e: # Handle violations of unique constraints, not-null, etc.
        conn.rollback()
        return jsonify({'error': str(e)}), 400
    except (Exception, psycopg2.DatabaseError) as e:
        conn.rollback()
        return jsonify({'error': 'An error occurred: ' + str(e)}), 500
    finally:
        cursor.close()
        conn.close()
    return jsonify({'success': f'{table_name.capitalize()} added successfully.'}), 201
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

@app.route('/add_student', methods=['POST'])
def add_student():
    data = request.json
    required_fields = ['name', 'email', 'hostelId']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('student', required_fields, values)

# Route for adding a book
@app.route('/add_book', methods=['POST'])
def add_book():
    data = request.json
    required_fields = ['isbn', 'title', 'author']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('book', required_fields, values)

# Route for adding a course
@app.route('/add_course', methods=['POST'])
def add_course():
    data = request.json
    required_fields = ['title', 'facultyId']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('course', required_fields, values)

@app.route('/add_faculty', methods=['POST'])
def add_faculty():
    data = request.json
    required_fields = ['email', 'name']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('faculty', required_fields, values)

@app.route('/add_hostel', methods=['POST'])
def add_menu():
    data = request.json 
    required_fields = ['hostelId', 'name', 'capacity', 'location']
    values = [data.get(field) for field in required_fields]
    # Simplified condition to check for missing values
    if not all(values):
        abort(400, 'Missing required data fields')
    return add_data('menu', required_fields, values)

@app.route('/add_menu', methods=['POST'])
def add_menu():
    data = request.json  # Ensure data is defined
    required_fields = ['day', 'timeOfDay', 'messName', 'items']
    values = [data.get(field) for field in required_fields]
    # Simplified condition to check for missing values
    if not all(values):
        abort(400, 'Missing required data fields')
    return add_data('menu', required_fields, values)

@app.route('/add_hostel', methods=['POST'])
def add_hostel():
    data = request.json
    required_fields = ['name', 'capacity', 'location']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('hostel', required_fields, values)

# Route for adding a maintenance request
@app.route('/add_maintenance', methods=['POST'])
def add_maintenance():
    data = request.json
    required_fields = ['hostelId', 'roomId', 'request_date', 'status', 'description', 'studentId']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('maintenance', required_fields, values)

# Route for adding a borrow record
@app.route('/add_borrow', methods=['POST'])
def add_borrow():
    data = request.json
    required_fields = ['isbn', 'studentId', 'dueDate', 'lateFees', 'returnDate']
    values = [data.get(field) for field in required_fields]
    # The original if condition checks that the first two values are not None or empty
    if not all(values[:2]):
        abort(400, 'Missing data fields')
    return add_data('borrow', required_fields, values)

# Route for adding an enrollment record
@app.route('/add_enrollment', methods=['POST'])
def add_enrollment():
    data = request.json
    required_fields = ['studentId', 'courseId']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('enrollment', required_fields, values)

# Route for adding a mess
@app.route('/add_mess', methods=['POST'])
def add_mess():
    data = request.json
    required_fields = ['messName', 'location', 'hostelId']
    values = [data.get(field) for field in required_fields]
    if not all(values):
        abort(400, 'Missing data fields')
    return add_data('mess', required_fields, values)


if __name__ == '__main__':
    app.run(debug=True)

