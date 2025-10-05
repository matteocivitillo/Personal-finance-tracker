import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';
import '../widgets/formWidget.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final transactionController = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1100;
    final isTablet = size.width >= 700 && size.width < 1100;

    Widget formSection = Expanded(child: FormWidget());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          if (isDesktop) {
            return Center(
              child: Container(
                width: width > 600 ? 600 : width,
                padding: const EdgeInsets.all(64.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Add a new transaction', style: TextStyle(fontSize: 22)),
                    const SizedBox(height: 16),
                    FormWidget(),
                  ],
                ),
              ),
            );
          } else if (isTablet) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Add a new transaction', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 12),
                  formSection,
                ],
              ),
            );
          } else {
            // Mobile
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Add a new transaction', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  formSection,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
