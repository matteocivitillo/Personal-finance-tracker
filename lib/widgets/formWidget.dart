import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';
import '../models/transaction.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final transactionController = Get.find<TransactionController>(); 
  DateTime? selectedDate;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
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
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: TransactionModel.categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: TransactionModel.categoryColors[category],
                      radius: 8,
                    ),
                    const SizedBox(width: 8),
                    Text(category),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
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
          Row(
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
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              final category = selectedCategory;
              final description = descriptionController.text;
              final date = selectedDate ?? DateTime.now();
              if (category == null || description.isEmpty || amount == 0.0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields and enter a valid amount')),
                );
                return;
              }
              final tx = TransactionModel(
                id: UniqueKey().toString(),
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
              descriptionController.clear();
              setState(() {
                selectedCategory = null;
                selectedDate = null;
              });
            },
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}
