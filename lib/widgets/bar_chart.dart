import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';

class CategoryBarChart extends StatelessWidget {
  final List<String> categories;
  final Map<String, double> expensesByCategory;
  final double width;
  final double maxY;
  final double minY;

  const CategoryBarChart({
    super.key,
    required this.categories,
    required this.expensesByCategory,
    required this.width,
    required this.maxY,
    required this.minY,
  });

  @override
  Widget build(BuildContext context) {
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
               color: TransactionModel.categoryColors[category] ?? Colors.grey,
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
                 final fontSize = width < 350 ? 8.0 : width < 400 ? 10.0 : width < 700 ? 12.0 : 14.0;
                 final text = Text(
                   categories[index],
                   style: TextStyle(fontSize: fontSize),
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   maxLines: 2,
                  );
                  if (width < 700) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Transform.rotate(
                          angle: -0.785398, 
                          child: text,
                        ),
                      ],
                    );
                  }
                  return text;
              }
              return const Text('');
             },
             reservedSize: 60,
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
  }
}
