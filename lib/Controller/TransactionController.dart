import 'package:personal_finance_tracker/models/transaction.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionController extends GetxController {
  final box = Hive.box('storage');

  // Observable variable for the list of transactions
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  // Observable variable for the total amount
  final RxDouble totalAmount = 0.0.obs;

  // Constructor: initializes state from the database
  TransactionController() {
    // Loads transactions from the Hive box only as Map
    final stored = box.values;
    if (stored.isNotEmpty) {
      transactions.assignAll(
        stored.whereType<Map>().map((e) => TransactionModel.fromJson(e))
      );
      totalAmount.value = transactions.fold(0.0, (sum, tx) => sum + tx.amount);
    }
  }

  // Method to add a transaction
  void addTransaction(TransactionModel tx) {
    transactions.add(tx);
    totalAmount.value += tx.amount;
    box.add(tx.toJson()); // Save as Map for compatibility
  }

  // Method to remove a transaction
  void removeTransaction(TransactionModel tx) {
    int index = transactions.indexOf(tx);
    if (index != -1) {
      transactions.removeAt(index);
      totalAmount.value -= tx.amount;
      box.deleteAt(index);
    }
  }

  // Getters for the list and total
  List<TransactionModel> get allTransactions => transactions;
  double get total => totalAmount.value;
  
}