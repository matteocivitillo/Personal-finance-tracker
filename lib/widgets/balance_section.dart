import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';

class BalanceSection extends StatelessWidget {
  final TransactionController transactionController;
  final double balanceFont;
  final double amountFont;
  const BalanceSection({super.key, required this.transactionController, required this.balanceFont, required this.amountFont});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your total balance',
          style: TextStyle(fontSize: balanceFont, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        Text(
          '€${transactionController.total.toStringAsFixed(2)}',
          style: TextStyle(fontSize: amountFont, color: Colors.green, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ],
    ));
  }
}
