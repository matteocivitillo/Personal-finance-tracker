import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/models/transaction.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  // Add your transaction management logic here
  final transaction = <TransactionModel>[].obs;
  final totalAmount = 0.0.obs;

  void addTransaction(TransactionModel tx) {
    transaction.add(tx);
    totalAmount.value += tx.amount;
  }

  void removeTransaction(TransactionModel tx) {
    transaction.remove(tx);
    totalAmount.value -= tx.amount;
  }

  List<TransactionModel> get allTransactions => transaction;
  double get total => totalAmount.value;
  
}