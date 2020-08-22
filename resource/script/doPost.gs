function doPost(request) {
  var sheetId = "{sheetId}";
  var result = { "status": "SUCCESS" };
  try {
    var activeSpreadsheet = SpreadsheetApp.openById(sheetId);
    if (activeSpreadsheet) {
      var parameter = request.parameter;
      var transactionDate = parameter.transactionDate;
      var type = parameter.type;
      var message = parameter.message;
      var cash = parameter.cash;
      var noteDateTime = parameter.noteDateTime;
      
      activeSpreadsheet.appendRow([transactionDate,type,message,cash,noteDateTime]);
    }
  } catch (exc) {
    result = { "status": "FAILED", "message": exc };
  }

  return ContentService.createTextOutput(JSON.stringify(result)).setMimeType(ContentService.MimeType.JSON);
}