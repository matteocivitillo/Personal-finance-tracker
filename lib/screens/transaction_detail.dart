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

    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1100;
    final isTablet = size.width >= 700 && size.width < 1100;
    final isMobile = size.width < 700;
    final horizontalPadding = isMobile ? 16.0 : isTablet ? 32.0 : 64.0;
    final titleFont = isMobile ? 20.0 : isTablet ? 26.0 : 32.0;
    final labelFont = isMobile ? 16.0 : isTablet ? 18.0 : 20.0;
    final valueFont = isMobile ? 18.0 : isTablet ? 22.0 : 26.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isDesktop ? 700 : double.infinity),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Transaction Details', style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    width: isMobile ? 32 : 48,
                    height: isMobile ? 32 : 48,
                    decoration: BoxDecoration(
                      color: transaction.categoryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(transaction.category, style: TextStyle(fontSize: valueFont, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 24),
              Text('Description', style: TextStyle(fontSize: labelFont, fontWeight: FontWeight.bold)),
              Text(transaction.description, style: TextStyle(fontSize: valueFont)),
              const SizedBox(height: 16),
              Text('Amount', style: TextStyle(fontSize: labelFont, fontWeight: FontWeight.bold)),
              Text('€${transaction.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: valueFont)),
              const SizedBox(height: 16),
              Text('Date', style: TextStyle(fontSize: labelFont, fontWeight: FontWeight.bold)),
              Text(transaction.date.toLocal().toString().split(' ')[0], style: TextStyle(fontSize: valueFont)),
            ],
          ),
        ),
      ),
    );
  }
}