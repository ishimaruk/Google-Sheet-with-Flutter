import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:Google_Sheet_with_Flutter/model/Transaction.dart';

class TransactionService {
  static const STATUS_SUCCESS = "SUCCESS";
  static const URL = "https://script.google.com/macros/s/{scriptId}/exec";

  static void submitForm(
      Transaction transaction, void Function(String) callback) async {
    try {
      await http.post(URL, body: transaction.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Transaction>> getList() async {
    return await http.get(URL).then((response) {
      var jsonList = convert.jsonDecode(response.body) as List;
      List<Transaction> list =
          jsonList.map((json) => Transaction.fromJson(json)).toList();
      list.sort((a, b) => b.getNoteDateTime().compareTo(a.getNoteDateTime()));
      return list;
    });
  }
}
