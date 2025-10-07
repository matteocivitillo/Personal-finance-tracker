import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'
;import 'screens/home_screen.dart';
import 'screens/add_transaction.dart';
import 'screens/stats_screen.dart';
import 'screens/transaction_detail.dart';
import 'package:get/get.dart';
import 'Controller/TransactionController.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('storage');
  Get.put(TransactionController());
  runApp(const PersonalFinanceApp());
}

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Tracker',
      theme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add': (context) => AddTransactionScreen(),
        '/stats': (context) => StatsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/transactionDetail') {
          final id = settings.arguments as String? ?? '';
          return MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(transactionId: id),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}