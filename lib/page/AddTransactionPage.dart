import 'package:flutter/material.dart';
import 'package:Google_Sheet_with_Flutter/model/Transaction.dart';
import 'package:Google_Sheet_with_Flutter/model/TransactionType.dart';
import 'package:Google_Sheet_with_Flutter/service/TransactionService.dart';

class AddTransactionPage extends StatefulWidget {
  AddTransactionPage({Key key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _transactionDate;
  TransactionType _transactionType;
  TextEditingController _messageController = TextEditingController();
  TextEditingController _cashController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transactionDate = DateTime.now();
    _transactionType = TransactionType.Income;
  }

  Widget showDate() {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text(
          '${_transactionDate.year} - ${_transactionDate.month} - ${_transactionDate.day}'),
      trailing: Icon(Icons.keyboard_arrow_down),
      onTap: () {
        chooseDate();
      },
    );
  }

  Future<void> chooseDate() async {
    DateTime chooseDateTime = await showDatePicker(
        context: context,
        initialDate: _transactionDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (chooseDateTime != null) {
      setState(() {
        _transactionDate = chooseDateTime;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      Transaction transaction = Transaction(
          _transactionDate,
          _transactionType,
          _messageController.text,
          int.parse(_cashController.text),
          new DateTime.now());

      TransactionService transactionService = TransactionService();

      _showSnackbar("กำลังบันทึก");

      transactionService.submitForm(transaction, (String response) {
        print("Response: $response");
        if (response == TransactionService.STATUS_SUCCESS) {
          _showSnackbar("บันทึกสำเร็จ");
           Navigator.pop(context);
        } else {
          _showSnackbar("Error!");
        }
      });
    }
  }

  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('บันทึกรายรับ/รายจ่าย'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      showDate(),
                      new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Radio(
                          value: TransactionType.Income,
                          groupValue: _transactionType,
                          onChanged:  (TransactionType value) {
                            setState(() {
                              _transactionType = value;
                            });
                          },
                        ),
                        new Text(
                         TransactionType.Income.name,
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: TransactionType.Expense,
                          groupValue: _transactionType,
                          onChanged:  (TransactionType value) {
                            setState(() {
                              _transactionType = value;
                            });
                          },,
                        ),
                        new Text(
                         TransactionType.Expense.name,
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                      TextFormField(
                        controller: _messageController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'ยังไม่ได้กรอกข้อมูลรายการ';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: 'รายการ'),
                      ),
                      TextFormField(
                        controller: _cashController,
                        validator: (value) {
                          if (value.isEmpty || int.parse(value) <= 0) {
                            return 'จำนวนเงินต้องมากกว่า 0';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        decoration: InputDecoration(labelText: 'จำนวนเงิน'),
                      ),
                    ],
                  ),
                )),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _submitForm,
              child: Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
