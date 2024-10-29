$(document).ready(function () {
    loadDatePicker();
    var getCurrentDate = getTodayDate();
    $("#fromDate").val(getCurrentDate);
    $("#toDate").val(getCurrentDate);
});

function runQAReport(){
    var qaReportTable = "";
    for(var i = 0; i < 10; i++){
        qaReportTable += '<tr><td>User'+ i +'</td><td>Completed</td><td>1992/02/21 12:02:21</td><td>1992/02/21 12:02:21</td><td>1992/02/21 12:02:21</td><td>1992/02/21 12:02:21</td></tr>';
    }
    $('#qaImageReporttblBody').append(qaReportTable);
    qaReportTableAlignment();
} 
    
function qaReportTableAlignment(){
    // Change the selector if needed
    var $table = $('table.scroll'),
        $bodyCells = $table.find('tbody tr:first').children(),
        colWidth;

    // Adjust the width of thead cells when window resizes
    $(window).resize(function() {
        // Get the tbody columns width array
        colWidth = $bodyCells.map(function() {
            return $(this).width();
        }).get();

        // Set the width of thead columns
        $table.find('thead tr').children().each(function(i, v) {
            $(v).width(colWidth[i]);
        });    
    }).resize(); // Trigger resize handler    
}
