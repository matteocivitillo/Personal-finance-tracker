import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Controller/TransactionController.dart';

// creare un grafico a barre che mostra le spese per categoria
class StatsScreen extends StatelessWidget {
  StatsScreen({super.key});
  final box = Hive.box('storage');
  final TransactionController transactionController = Get.put(TransactionController());

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
          // Font scaling
          final titleFont = width < 400 ? 18.0 : width < 700 ? 22.0 : 28.0;
          // Margini laterali responsive
          final horizontalPadding = width < 700 ? 8.0 : width < 1000 ? 16.0 : 32.0;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
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
                    // Fixed categories
                    final categories = [
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
                    return BarChart(
                      BarChartData(
                        barGroups: categories.asMap().entries.map((entry) {
                          final index = entry.key;
                          final category = entry.value;
                          final amount = expensesByCategory[category]!;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: amount,
                                color: categoryColors[category] ?? Colors.grey,
                                width: width < 700 ? 20 : 30,
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < categories.length) {
                                  return Text(
                                    categories[index],
                                    style: TextStyle(fontSize: width < 400 ? 10 : 12),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 60, // Increased for longer category names
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '€${value.toInt()}',
                                  style: TextStyle(fontSize: width < 400 ? 10 : 12),
                                );
                              },
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                        maxY: maxY,
                        minY: minY,
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
