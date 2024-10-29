

var gridTable = ["", "top", "offset", "href", "attr", "animate", 
               "html, body", "click", "a.smoothscroll", "change", "#tabletype", 
               "#tableborder", "#tablewidth", "#tablewidthunit", "#tablecellpadding", 
               "tablazatEditorok", "removeClass", ".editorContainer", 
               ".divTable{\n\tdisplay: table;\n\twidth: 100%;\n}\n.divTableRow {\n\tdisplay: table-row;\n}\n.divTableHeading {\n\tbackground-color: #EEE;\n\tdisplay: table-header-group;\n}\n.divTableCell, .divTableHead {\n\tborder: 1px solid #999999;\n\tdisplay: table-cell;\n\tpadding: 3px 10px;\n}\n.divTableHeading {\n\tbackground-color: #EEE;\n\tdisplay: table-header-group;\n\tfont-weight: bold;\n}\n.divTableFoot {\n\tbackground-color: #EEE;\n\tdisplay: table-footer-group;\n\tfont-weight: bold;\n}\n.divTableBody {\n\tdisplay: table-row-group;\n}",
               "setValue", "mousedown", "#tableConvert a", "setContent", "activeEditor", "#undoButt", "#tableConvert", 
               "<table>\n\t<thead></thead><tbody></tbody></table>\n<p>&nbsp;</p>", 
               "#loadDemoTable", "addClass", "#closeCss", "data-iksz", "data-ipsz", " x ", 
               "html", "#tableDimmensions", "left", "px", "css", "selectedCell", "each", 
               ".tableCell", "hide", ".howToUseInstruction", "#indentCode", "higlightCell", 
               "mouseout", "#hoverTableCont", "mouseover",
               "toggle", ".cellPaddingContainer", "ready", "resizable", 
               ".CodeMirror", "getContent", "elm1", "get", 
               "<table", ">", "<thead", "<thead>", "</tbody>", "</thead>", "</tfoot>", 
               "</td>", "</tr>", "</th>", "value", "table", "<table ", 'style="', "width: ", 
               "%;", "px;", '" ', 'border="', '"', ' cellpadding="', ">\n<tbody>", 
               "\n<tr>", "\n<td>&nbsp;</td>", "\n</tr>", "\n</tbody>\n</table>"],
    curX = 0,
    curY = 0,
    columns = 1,
    rows = 1,
    seg = gridTable[0],
    ezX = 0,
    text = gridTable[0],
    undotext = gridTable[0],
    ezY = 0,
    wysiwygActive = 0,
    indentpressed = 0;

$(document)[gridTable[50]](function() 
{
    $(gridTable[10])[gridTable[9]](function() 
    {
        createTable(columns, rows), setTimeout(function() 
        {
            createTable(columns, rows)
        }, 100)
    }), 
        
    $(gridTable[40])[gridTable[20]](function(a) 
    {
        curX = Number($(this)[gridTable[4]](gridTable[30])), 
        curY = Number($(this)[gridTable[4]](gridTable[31])), 
        columns = curX, 
        rows = curY, 
        $(gridTable[34])[gridTable[33]](curY + gridTable[32] + curX),
        $(gridTable[34])[gridTable[37]](gridTable[35], 17 * curX - 60 + gridTable[36]), 
        $(gridTable[34])[gridTable[37]](gridTable[1], 17 * curY - 190 + gridTable[36]), 
            
        $(gridTable[40])[gridTable[39]](function() 
        {
        $(this)[gridTable[16]](gridTable[38]),
            ezX = Number($(this)[gridTable[4]](gridTable[30])),
            ezY = Number($(this)[gridTable[4]](gridTable[31])), 
            ezX <= curX && ezY <= curY && $(this)[gridTable[28]](gridTable[38])
        }), 
        $(gridTable[42])[gridTable[41]](), 
        createTable(columns, rows)
    }),  
        
    $(gridTable[46])[gridTable[45]](function(a) 
    {
        $(gridTable[40])[gridTable[39]](function() 
        {
            $(this)[gridTable[16]](gridTable[44])
        }), 
        $(gridTable[34])[gridTable[33]](rows + gridTable[32] + columns),
        $(gridTable[34])[gridTable[37]](gridTable[35], 17 * columns - 75 + gridTable[36]),
        $(gridTable[34])[gridTable[37]](gridTable[1], 17 * rows - 205 + gridTable[36])
        
        var selectedCell = $(".selectedCell").length;
        
        var selectedCelliksz = $(".selectedCell")[selectedCell - 1].dataset.iksz; // columns 
        var selectedCellipsz = $(".selectedCell")[selectedCell - 1].dataset.ipsz; // rows
        
        $('#tableDimmensions').html(selectedCellipsz + " x " + selectedCelliksz);
    }), 
        
    $(gridTable[40])[gridTable[47]](function() 
    {
        curX = Number($(this)[gridTable[4]](gridTable[30])), curY = Number($(this)[gridTable[4]](gridTable[31])), 
            $(gridTable[34])[gridTable[33]](curY + gridTable[32] + curX), 
            $(gridTable[34])[gridTable[37]](gridTable[35], 17 * curX - 60 + gridTable[36]),
            $(gridTable[34])[gridTable[37]](gridTable[1], 17 * curY - 190 + gridTable[36]), 
            
        $(gridTable[40])[gridTable[39]](function() 
        {
            $(this)[gridTable[16]](gridTable[44]), 
            ezX = Number($(this)[gridTable[4]](gridTable[30])),
            ezY = Number($(this)[gridTable[4]](gridTable[31])), 
            ezX <= curX && ezY <= curY && $(this)[gridTable[28]](gridTable[44])
        })
    })
});

function createTable(columns, rows){
    studyLayoutValue = rows+"x"+columns;
    dicomViewer.tools.changeStudyLayout(rows, columns);
    hideAnimationContainer();
}

