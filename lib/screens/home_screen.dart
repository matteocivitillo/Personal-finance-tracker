import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';
import '../widgets/balance_section.dart';
import '../widgets/button_section.dart';
import '../widgets/past_transactions.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TransactionController transactionController = Get.find<TransactionController>(); // usato solo per balance

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1100;
    final isTablet = size.width >= 700 && size.width < 1100;
    final isMobile = size.width < 700;
    final width = size.width;
    final horizontalPadding = isMobile ? 16.0 : isTablet ? 16.0 : 32.0;
    final balanceFont = width < 400 ? 18.0 : width < 700 ? 22.0 : 28.0;
    final amountFont = width < 400 ? 24.0 : width < 700 ? 32.0 : 40.0;
    final buttonPadding = width < 400 ? EdgeInsets.symmetric(horizontal: 12, vertical: 8) : EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Finance Tracker'),
        centerTitle: true,
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxContentWidth = isDesktop ? 900.0 : constraints.maxWidth;
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0), // bottom margin
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: FractionallySizedBox(
                        widthFactor: isDesktop ? 0.7 : isTablet ? 0.9 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BalanceSection(
                              transactionController: transactionController,
                              balanceFont: balanceFont,
                              amountFont: amountFont,
                            ),
                            const SizedBox(height: 32),
                            isMobile
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/add');
                                      },
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Transaction'),
                                      style: ElevatedButton.styleFrom(
                                        padding: buttonPadding,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/stats');
                                      },
                                      icon: const Icon(Icons.bar_chart),
                                      label: const Text('View Stats'),
                                      style: ElevatedButton.styleFrom(
                                        padding: buttonPadding,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ],
                                )
                              : ButtonSection(buttonPadding: buttonPadding),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Past Transactions',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: PastTransactions(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


