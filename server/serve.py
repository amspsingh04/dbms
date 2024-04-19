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
    except psycopg2.IntegrityError as e: 
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

lis=["book","borrow","course","enrollment", "faculty","hostel","maintenance","menu","mess","student"]

@app.route('/<item>', methods=['GET'])
def get_item(item):
    # Check if the requested item is in the list
    if item in lis:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute(f'SELECT * FROM {item};')
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)

@app.route('/add_student', methods=['POST'])
def add_student():
    data = request.json
    required_fields = ['studentId','name', 'email', 'hostelId']
    values = [data.get(field) for field in required_fields]
    
    return add_data('student', required_fields, values)

@app.route('/add_book', methods=['POST'])
def add_book():
    data = request.json
    required_fields = ['isbn', 'title','author']
    values = [data.get(field) for field in required_fields]
    return add_data('book', required_fields, values)

@app.route('/add_course', methods=['POST'])
def add_course():
    data = request.json
    required_fields = ['courseId','title','facultyId']
    values = [data.get(field) for field in required_fields]
    
    return add_data('course', required_fields, values)

@app.route('/add_faculty', methods=['POST'])
def add_faculty():
    data = request.json
    required_fields = ['facultyId','email', 'name']
    values = [data.get(field) for field in required_fields]
    
    return add_data('faculty', required_fields, values)

@app.route('/add_hostel', methods=['POST'])
def add_hostel():
    data = request.json 
    required_fields = ['hostelId', 'name', 'capacity', 'location']
    values = [data.get(field) for field in required_fields]    
    return add_data('hostel', required_fields, values)

@app.route('/add_menu', methods=['POST'])
def add_menu():
    data = request.json  
    required_fields = ['day', 'timeOfDay', 'messName', 'items']
    values = [data.get(field) for field in required_fields]
    
    return add_data('menu', required_fields, values)


@app.route('/add_maintenance', methods=['POST'])
def add_maintenance():
    data = request.json
    required_fields = ['requestId','hostelId', 'roomId', 'request_date', 'status', 'description', 'studentId']
    values = [data.get(field) for field in required_fields]
    
    return add_data('maintenance', required_fields, values)

@app.route('/add_borrow', methods=['POST'])
def add_borrow():
    data = request.json
    required_fields = ['isbn', 'studentId', 'dueDate', 'lateFees', 'returnDate']
    values = [data.get(field) for field in required_fields]    
    return add_data('borrow', required_fields, values)

@app.route('/add_enrollment', methods=['POST'])
def add_enrollment():
    data = request.json
    required_fields = ['studentId', 'courseId']
    values = [data.get(field) for field in required_fields]
    
    return add_data('enrollment', required_fields, values)

@app.route('/add_mess', methods=['POST'])
def add_mess():
    data = request.json
    required_fields = ['messName', 'location', 'hostelId']
    values = [data.get(field) for field in required_fields]
    
    return add_data('mess', required_fields, values)

dic={"book":"isbn","borrow":"isbn","course":"courseId","enrollment":"studentId", "faculty":"facultyId","hostel":"hostelId","maintenance":"requestId","menu":"day","mess":"messName","student":"studentId"}



@app.route('/get_record', methods=['GET'])
def get_record():
    table_name = request.args.get('table_name')
    primary_key = request.args.get('primary_key')
    if table_name in dic:
        primary_key_column = dic[table_name]
        query = f"SELECT * FROM {table_name} WHERE \"{primary_key_column}\" = %s;"
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute(query, (primary_key,))
        print(cursor)
        record = cursor.fetchone()
        cursor.close()
        conn.close()
        return jsonify(record)
        

if __name__ == '__main__':
    app.run(debug=True)

