function doGet(request) {
  var sheetId = "{sheetId}";
  var activeSpreadsheet = SpreadsheetApp.openById(sheetId);
  var result = [];
  if (activeSpreadsheet) {
    var values = activeSpreadsheet.getActiveSheet().getDataRange().getValues();
    
    // Iterate values with out header
    for (var i = 1; i < values.length; i++) {
      var row = values[i];
      var data = {};
      
      data['transactionDate'] = row[0];
      data['type'] = row[1];
      data['message'] = row[2];
      data['cash'] = row[3];
	  data['noteDateTime'] = row[4];
      
      result.push(data);
    }
  }
  return ContentService.createTextOutput(JSON.stringify(result)).setMimeType(ContentService.MimeType.JSON);
}