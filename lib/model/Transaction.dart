import 'package:Google_Sheet_with_Flutter/model/TransactionType.dart';

class Transaction {
  DateTime _transactionDate;
  TransactionType _type;
  String _message;
  int _cash;
  DateTime _noteDateTime;

  Transaction(this._transactionDate, this._type, this._message, this._cash,
      this._noteDateTime);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    DateTime transactionDate = DateTime.parse(json['transactionDate']);
    TransactionType type = TransactionTypeExtension.parse(json['type']);
    String message = json['message'];
    int cash = json['cash'];
    DateTime noteDateTime = DateTime.parse(json['noteDateTime']);
    return Transaction(transactionDate, type, message, cash, noteDateTime);
  }

  Map<String, dynamic> toJson() => {
        'transactionDate': this._transactionDate.toIso8601String(),
        'type': this._type.name,
        'message': this._message,
        'cash': this._cash.toString(),
        'noteDateTime': this._noteDateTime.toIso8601String(),
      };

  DateTime getNoteDateTime() {
    return this._noteDateTime;
  }

  DateTime getTransactionDate() {
    return this._transactionDate;
  }

  TransactionType getType() {
    return this._type;
  }

  String getMessage() {
    return this._message;
  }

  int getCash() {
    return this._cash;
  }
}
