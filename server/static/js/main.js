$(document).ready(function() {
    function loadData(endpoint) {
        $.getJSON(endpoint, function(data) {
            const $table = $('#data-table');
            $table.find('thead').empty();
            $table.find('tbody').empty();
            
            if (data.length > 0) {
                const headers = Object.keys(data[0]);
                let headerRow = '<tr>';
                headers.forEach(header => {
                    headerRow += `<th>${header}</th>`;
                });
                headerRow += '</tr>';
                $table.find('thead').append(headerRow);

                data.forEach(row => {
                    let rowHtml = '<tr>';
                    headers.forEach(header => {
                        rowHtml += `<td>${row[header]}</td>`;
                    });
                    rowHtml += '</tr>';
                    $table.find('tbody').append(rowHtml);
                });
            } else {
                $table.find('tbody').append('<tr><td colspan="' + headers.length + '">No data available.</td></tr>');
            }
        }).fail(function() {
            $table.find('tbody').append('<tr><td colspan="' + headers.length + '">Error fetching data. Please try again later.</td></tr>');
        });
    }
    
    $('#data-selector').change(function() {
        const selectedData = $(this).val();
        if (selectedData) {
            $('#add-data-button').show();
            loadData('/' + selectedData);
        } else {
            $('#add-data-button').hide();
        }
    });
    
    function populateForm(selectedDataType) {
        $('#add-data-form').empty();
        const formFieldsByDataType = {
            'student': [
                { name: 'studentId', type: 'number', placeholder: 'Student ID' },
                { name: 'name', type: 'text', placeholder: 'Name' },
                { name: 'email', type: 'email', placeholder: 'Email' },
                { name: 'hostelId', type: 'number', placeholder: 'Hostel ID' }
            ],
            'book': [
                { name: 'isbn', type: 'text', placeholder: 'ISBN' },
                { name: 'title', type: 'text', placeholder: 'Title' },
                { name: 'author', type: 'text', placeholder: 'Author' }
            ],
            'course': [
                { name: 'courseId', type: 'number', placeholder: 'Course ID' },
                { name: 'title', type: 'text', placeholder: 'Course Title' },
                { name: 'facultyId', type: 'number', placeholder: 'Faculty ID' }
            ],
            'faculty': [
                { name: 'facultyId', type: 'number', placeholder: 'Faculty ID' },
                { name: 'name', type: 'text', placeholder: 'Name' },
                { name: 'email', type: 'email', placeholder: 'Email' }
            ],
            'menu': [
                { name: 'day', type: 'text', placeholder: 'Day' },
                { name: 'timeOfDay', type: 'text', placeholder: 'Time Of Day' },
                { name: 'messName', type: 'text', placeholder: 'Mess Name' },
                { name: 'items', type: 'text', placeholder: 'Items' }
            ],
            'hostel': [
                { name: 'hostelId', type: 'number', placeholder: 'Hostel ID' },
                { name: 'name', type: 'text', placeholder: 'Name' },
                { name: 'capacity', type: 'number', placeholder: 'Capacity' },
                { name: 'location', type: 'text', placeholder: 'Location' }
            ],
            'maintenance': [
                { name: 'requestId', type: 'number', placeholder: 'Request ID' },
                { name: 'hostelId', type: 'number', placeholder: 'Hostel ID' },
                { name: 'roomId', type: 'number', placeholder: 'Room ID' },
                { name: 'request_date', type: 'date', placeholder: 'Request Date' },
                { name: 'status', type: 'text', placeholder: 'Status' },
                { name: 'description', type: 'text', placeholder: 'Description' },
                { name: 'studentId', type: 'number', placeholder: 'Student ID' }
            ],
            'borrow': [
                { name: 'isbn', type: 'text', placeholder: 'ISBN' },
                { name: 'studentId', type: 'number', placeholder: 'Student ID' },
                { name: 'dueDate', type: 'date', placeholder: 'Due Date' },
                { name: 'lateFees', type: 'number', placeholder: 'Late Fees' },
                { name: 'returnDate', type: 'date', placeholder: 'Return Date' }
            ],
            'enrollment': [
                { name: 'studentId', type: 'number', placeholder: 'Student ID' },
                { name: 'courseId', type: 'number', placeholder: 'Course ID' }
            ],
            'mess': [
                { name: 'messName', type: 'text', placeholder: 'Mess Name' },
                { name: 'location', type: 'text', placeholder: 'Location' },
                { name: 'hostelId', type: 'number', placeholder: 'Hostel ID' }
            ]
        };
        
        const fields = formFieldsByDataType[selectedDataType];
        if (fields) {
            fields.forEach(field => {
                let inputHtml = `<label for="${field.name}">${field.placeholder}</label>` +
                    `<input type="${field.type}" id="${field.name}" name="${field.name}" required placeholder="${field.placeholder}"><br>`;
                $('#add-data-form').append(inputHtml);
            });
        }
    }
    
    $('#add-data-button').click(function() {
        const selectedDataType = $('#data-selector').val();
        populateForm(selectedDataType);
        $('#add-data-modal').show();
    });
    $('.close').click(function() {
        $('#add-data-modal').hide(); // Use .hide() to hide the modal
    });
    
    $('#add-data-form').on('submit', function(e) {
        e.preventDefault();
        const selectedDataType = $('#data-selector').val();
        const endpoint = '/add_' + selectedDataType;
        const formData = $(this).serializeArray().reduce(function(obj, item) {
            obj[item.name] = item.value;
            return obj;
        }, {});
        
        $.ajax({
            url: endpoint,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function() {
                alert('Data added successfully!');
                $('#add-data-modal').hide();
                loadData('/' + selectedDataType);
            },
            error: function(response) {
                alert('Error adding data: ' + response.responseText);
            }
        });
    });
});
