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

    // Event handler for the dropdown's change event
    $('#data-selector').change(function() {
        const selectedData = $(this).val();
        if (selectedData) {
            loadData('/' + selectedData);
        }
    });
});

