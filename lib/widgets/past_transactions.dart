import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';

class PastTransactions extends StatelessWidget {
  const PastTransactions({super.key}); 

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    return Obx(() => ListView(
      children: transactionController.allTransactions
          .map((tx) => Card(
                child: ListTile(
                  title: Text(tx.description),
                  subtitle: Text(tx.date.toString()),
                  trailing: Text('€${tx.amount.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.pushNamed(context, '/transactionDetail', arguments: tx.id);
                  },
                ),
              ))
          .toList(),
    ));
  }
}
