import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';
import '../models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final transactionController = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;
    final isTablet = size.width >= 600 && size.width < 900;

    Widget formSection = Expanded(child: FormWidget());
    Widget transactionSection = Expanded(
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
    );

    Widget pastTransactionText = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Text(
        "Past Transactions",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        textAlign: TextAlign.left,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isDesktop) {
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Add a new transaction', style: TextStyle(fontSize: 22)),
                        const SizedBox(height: 16),
                        FormWidget(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        pastTransactionText,
                        Expanded(child: transactionSection),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (isTablet) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add a new transaction', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 12),
                  formSection,
                  pastTransactionText,
                  transactionSection,
                ],
              ),
            );
          } else {
            // Mobile
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add a new transaction', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  formSection,
                  pastTransactionText,
                  transactionSection,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

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

  final List<String> categories = [
    'Supermarkets',
    'Transfers',
    'Bars and Restaurants',
    'Transport',
    'Entertainment',
    'Household Expenses',
  ];

  final Map<String, Color> categoryColors = {
    'Supermarkets': Colors.blue,
    'Transfers': Colors.green,
    'Bars and Restaurants': Colors.red,
    'Transport': Colors.orange,
    'Entertainment': Colors.purple,
    'Household Expenses': Colors.teal,
  };

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
            value: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: categoryColors[category],
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
