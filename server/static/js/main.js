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
        // Show the modal window
        $('#add-data-modal').show();

        // Populate the modal with a form based on the selected data type
        const selectedDataType = $('#data-selector').val();
        if (selectedDataType) {
            // An example of how you might start a request to get form fields
            // $.getJSON('/get_form_fields/' + selectedDataType, function(fields) {
            //     // Generate the form using the fields provided by the server
            // });
        }

        // Rest of the logic to generate the form goes here
    });

    // Event handler for 'Submit Data' button click (within the modal form)
    $('#submit-data-button').click(function() {
        // Gather the form data and perform the form submission logic here
    });

    // When the user clicks on <span> (x), close the modal
    $('.close').click(function() {
        $('#add-data-modal').hide();
    });
});
