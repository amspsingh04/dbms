// static/js/main.js
$(document).ready(function() {
    function loadData(endpoint) {
        $.getJSON(endpoint, function(data) {
            const $table = $('#data-table');
            $table.find('thead').empty();
            $table.find('tbody').empty();
            
            if (data.length > 0) {
                // Create headers
                const headers = Object.keys(data[0]);
                let headerRow = '<tr>';
                for (let header of headers) {
                    headerRow += `<th>${header}</th>`;
                }
                headerRow += '</tr>';
                $table.find('thead').append(headerRow);

                // Append data to table
                for (let row of data) {
                    let rowHtml = '<tr>';
                    for (let header of headers) {
                        rowHtml += `<td>${row[header]}</td>`;
                    }
                    rowHtml += '</tr>';
                    $table.find('tbody').append(rowHtml);
                }
            } else {
                // No data found message or empty state can be displayed here
                $table.find('tbody').append('<tr><td colspan="' + headers.length + '">No data available.</td></tr>');
            }
        }).fail(function(jqXHR, textStatus, errorThrown) {
            console.error('Error fetching data: ' + textStatus);
            // Optionally alert the user to the error here, for example:
            // alert('Failed to fetch data. Please try again later.');
            $table.find('tbody').append('<tr><td colspan="' + headers.length + '">Error fetching data. Please try again later.</td></tr>');
        });
    }

    $('#data-selector').change(function() {
        const selectedData = $(this).val();
        if (selectedData) {
            // Show the Add Data button when a data type is selected
            $('#add-data-button').show();

            // Optionally: Load the data for the selected data type
            loadData('/' + selectedData);

            // ... You can also load the form structure for the modal here, if needed ...
        } else {
            // Hide the Add Data button when no data type is selected
            $('#add-data-button').hide();
        }
    });

    // Event handler for 'Add Data' button click
    $('#add-data-button').click(function() {
        // Clear previous form
        $('#add-data-form').empty();

        // Show the modal window
        $('#add-data-modal').show();

        // Logic to add input fields based on the selected data type
        const selectedDataType = $('#data-selector').val();
        if (selectedDataType) {
            // This is just an example, you'll need endpoint(s) to get form fields dynamically from the backend
            const formFieldsByDataType = {
                'students': [
                    { name: 'name', type: 'text', placeholder: 'Enter name' },
                    { name: 'email', type: 'email', placeholder: 'Enter email' },
                    { name: 'hostelId', type: 'number', placeholder: 'Enter Hostel ID' }
                ],
                // Define similar structure for other data types...
            };

            const fields = formFieldsByDataType[selectedDataType];
            if (fields) {
                for (let field of fields) {
                    let inputHtml = `<label for="${field.name}">${field.placeholder}</label><input type="${field.type}" id="${field.name}" name="${field.name}" required placeholder="${field.placeholder}">`;
                    $('#add-data-form').append(inputHtml);
                }
            }
        }
    });

    // Event handler for 'Submit Data' button click (within the modal form)
    $('#submit-data-button').click(function(e) {
        e.preventDefault(); // Prevent default form submission

        const selectedDataType = $('#data-selector').val();
        const endpoint = '/add_' + selectedDataType; // Make sure this matches your Flask route
        const formData = {};
        
        $('#add-data-form').find('input').each(function () {
            formData[$(this).attr('name')] = $(this).val();
        });

        $.ajax({
            url: endpoint,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(formData),
            success: function(response) {
                alert('Data added successfully!');
                $('#add-data-modal').hide();
                loadData('/' + selectedDataType); // Reload the data table
            },
            error: function(response) {
                alert('Error adding data: ' + response.responseText);
            }
        });
    });

    // Rest of the code
});