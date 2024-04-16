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
            }
        }).fail(function(jqXHR, textStatus, errorThrown) {
            console.error('Error fetching data: ' + textStatus);
            // Optionally alert the user to the error here.
        });
    }

    // Event handlers for buttons
    $('#load-students').click(function() {
        loadData('/students');
    });

    $('#load-books').click(function() {
        loadData('/books');
    });

    $('#load-courses').click(function() {
        loadData('/courses');
    });

    // Add similar click handlers for other buttons and endpoints.
});
