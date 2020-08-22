enum TransactionType { Income, Expense }
const String _income = "รายรับ";
const String _expense = "รายจ่าย";

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.Income:
        return _income;
      case TransactionType.Expense:
        return _expense;
      default:
        return "";
    }
  }

  static TransactionType parse(String name) {
    if (name == _income) {
      return TransactionType.Income;
    } else if (name == _expense) {
      return TransactionType.Expense;
    }
    return null;
  }
}
