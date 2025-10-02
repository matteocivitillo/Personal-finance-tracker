import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Form to add a new transaction'),
              Padding(
                padding: EdgeInsets. symmetric(horizontal: 32.0),
                child: TransactionCard(
                  title: 'Grocery Shopping',
                  amount: '-\$50.00',
                  date: '2024-06-01',
                ),
              ),
            ],
          ),
        ),
    );
  }
}


class TransactionCard extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(amount),
        onTap: () {
          // Navigate to transaction detail screen
          Navigator.pushNamed(context, '/detail', arguments: title);
        },
      ),
    );
  }
}
