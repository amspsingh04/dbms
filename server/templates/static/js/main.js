// static/js/main.js
function fetchData(endpoint) {
    $.ajax({
        url: endpoint,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            // Empty the current table
            $('#data-table thead').empty();
            $('#data-table tbody').empty();

            // Assuming the JSON data is an array of objects
            if (data.length > 0) {
                const headers = Object.keys(data[0]);
                let theadContent = '<tr>';
                headers.forEach(header => {
                    theadContent += `<th>${header}</th>`;
                });
                theadContent += '</tr>';
                
                $('#data-table thead').append(theadContent);

                data.forEach(row => {
                    let rowContent = '<tr>';
                    headers.forEach(header => {
                        rowContent += `<td>${row[header]}</td>`;
                    });
                    rowContent += '</tr>';
                    $('#data-table tbody').append(rowContent);
                });
            }
        },
        error: function(error) {
            console.error('Error fetching data: ', error);
        }
    });
}

$('#load-students').click(function() {
    fetchData('/students');
});

$('#load-books').click(function() {
    fetchData('/books');
});

$('#load-courses').click(function() {
    fetchData('/courses');
});

// ... More click handlers for other buttons
