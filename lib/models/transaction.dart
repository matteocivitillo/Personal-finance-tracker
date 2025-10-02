class TransactionModel {
  final double amount;        // positivo = entrata, negativo = spesa
  final String category;
  final String description;
  final DateTime date;

  TransactionModel({
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'category': category,
    'description': description,
    'date': date.toIso8601String(),
  };

  factory TransactionModel.fromJson(Map data) {
    return TransactionModel(
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      description: data['description'] as String,
      date: DateTime.parse(data['date'] as String),
    );
  }
}
