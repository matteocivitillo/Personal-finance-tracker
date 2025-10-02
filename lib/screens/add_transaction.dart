import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';
import '../models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final transactionController = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Form to add a new transaction'),
              Expanded(child: FormWidget()),
              Expanded(
                child: Obx(() => ListView(
                  children: transactionController.allTransactions
                      .map((tx) => Card(
                            child: ListTile(
                              title: Text(tx.description),
                              subtitle: Text(tx.date.toString()),
                              trailing: Text('€${tx.amount.toStringAsFixed(2)}'),
                            ),
                          ))
                      .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class FormWidget extends StatelessWidget {
  const FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    final transactionController = Get.find<TransactionController>();
    DateTime? selectedDate;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                children: [
                  Expanded(
                    child: Text(selectedDate == null
                        ? 'No date selected'
                        : 'Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              final category = categoryController.text;
              final description = descriptionController.text;
              final date = selectedDate ?? DateTime.now();
              if (category.isEmpty || description.isEmpty || amount == 0.0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields and enter a valid amount')),
                );
                return;
              }
              final tx = TransactionModel(
                amount: amount,
                category: category,
                description: description,
                date: date,
              );
              transactionController.addTransaction(tx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction added!')),
              );
              amountController.clear();
              categoryController.clear();
              descriptionController.clear();
            },
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}
