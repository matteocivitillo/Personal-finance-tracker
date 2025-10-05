import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';
import '../models/transaction.dart';
import '../widgets/bar_chart.dart';

// creare un grafico a barre che mostra le spese per categoria
class StatsScreen extends StatelessWidget {
  StatsScreen({super.key});
  final box = Hive.box('storage');
  final TransactionController transactionController = Get.find<TransactionController>();
  final List<String> categories = TransactionModel.categories;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;
    final appBarHeight = isWide ? 80.0 : 70.0;
    final appBarFontSize = isWide ? 28.0 : 18.0;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Container(
            alignment: Alignment.center,
            height: appBarHeight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isWide ? 32.0 : 8.0, // left
                appBarHeight * 0.25,  // top
                isWide ? 32.0 : 8.0, // right
                0,                   // bottom
              ),
              child: Text(
                'Statistics',
                style: TextStyle(
                  fontSize: appBarFontSize,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 4,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isDesktop = width >= 1100;
          final isTablet = width >= 700 && width < 1100;
          final isMobile = width < 700;
          // Font scaling
          final titleFont = width < 400 ? 18.0 : width < 700 ? 22.0 : 28.0;
          // Margini laterali responsive
          final horizontalPadding = isMobile ? 8.0 : isTablet ? 16.0 : 32.0;
          Widget content = Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                'Net Amount by Category',
                style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  final categories = TransactionModel.categories;
                  // Initialize expenses map
                  final expensesByCategory = <String, double>{};
                  for (final cat in categories) {
                    expensesByCategory[cat] = 0.0;
                  }
                  // Sum net amounts for each category
                  for (final transaction in transactionController.transactions) {
                    if (categories.contains(transaction.category)) {
                      expensesByCategory[transaction.category] = expensesByCategory[transaction.category]! + transaction.amount;
                    }
                  }
                  final values = expensesByCategory.values;
                  final maxY = values.isEmpty ? 100.0 : values.map((v) => v.abs()).reduce((a, b) => a > b ? a : b) * 1.2;
                  final minY = values.isEmpty ? -100.0 : values.reduce((a, b) => a < b ? a : b) * 1.2;
                  return CategoryBarChart(
                    categories:categories,
                    expensesByCategory: expensesByCategory,
                    width: width,
                    maxY: maxY,
                    minY: minY,
                  );
                }),
              ),
            ],
          );
          if (isDesktop) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: content,
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: content,
            );
          }
        },
      ),
    );
  }
}
