import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();
    final transaction = transactionController.allTransactions.firstWhereOrNull((tx) => tx.id == transactionId);

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Detail'),
        ),
        body: const Center(
          child: Text('Transaction not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${transaction.description}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Amount: €${transaction.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Category: ${transaction.category}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Date: ${transaction.date.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: transaction.categoryColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}