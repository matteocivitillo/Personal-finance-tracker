import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  static const List<String> categories = [
    'Supermarkets',
    'Transfers',
    'Restaurants',
    'Transport',
    'Entertainment',
    'Household',
  ];

  TransactionModel({
    required this.id,
    required this.amount,
    required String category,
    required this.description,
    required this.date,
  }) : assert(categories.contains(category),
      'Category must be one of: $categories'),
    category = category;

  static Map<String, Color> categoryColors = {
    'Supermarkets': Colors.blue,
    'Transfers': Colors.green,
    'Restaurants': Colors.red,
    'Transport': Colors.orange,
    'Entertainment': Colors.purple,
    'Household': Colors.teal,
  };

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'category': category,
    'description': description,
    'date': date.toIso8601String(),
  };

  factory TransactionModel.fromJson(Map data) {
    return TransactionModel(
      id: data['id'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      description: data['description'] as String,
      date: DateTime.parse(data['date'] as String),
    );
  }

  Color get categoryColor => categoryColors[category] ?? Colors.grey;
}
