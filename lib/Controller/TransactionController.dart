import 'package:personal_finance_tracker/models/transaction.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionController extends GetxController {
  final box = Hive.box('storage');

  // Variabile osservabile per la lista delle transazioni
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  // Variabile osservabile per il totale
  final RxDouble totalAmount = 0.0.obs;

  // Costruttore: inizializza lo stato dal database
  TransactionController() {
    // Carica le transazioni dal box Hive solo come Map
    final stored = box.values;
    if (stored.isNotEmpty) {
      transactions.assignAll(
        stored.whereType<Map>().map((e) => TransactionModel.fromJson(e))
      );
      totalAmount.value = transactions.fold(0.0, (sum, tx) => sum + tx.amount);
    }
  }

  // Metodo per aggiungere una transazione
  void addTransaction(TransactionModel tx) {
    transactions.add(tx);
    totalAmount.value += tx.amount;
    box.add(tx.toJson()); // Salva come Map per compatibilità
  }

  // Metodo per rimuovere una transazione
  void removeTransaction(TransactionModel tx) {
    int index = transactions.indexOf(tx);
    if (index != -1) {
      transactions.removeAt(index);
      totalAmount.value -= tx.amount;
      box.deleteAt(index);
    }
  }

  // Getter per la lista e il totale
  List<TransactionModel> get allTransactions => transactions;
  double get total => totalAmount.value;
  
}