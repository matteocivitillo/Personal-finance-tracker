import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'
;
import "models/transaction.dart";
import 'screens/home_screen.dart';
import 'screens/add_transaction.dart';
import 'screens/stats_screen.dart';
import 'screens/transaction_detail.dart';



// Personal finance tracker (entering income and spending, looking into spending per category, showing statistics over time)
Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox('storage');
    runApp(const PersonalFinanceApp());
}

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add': (context) => AddTransactionScreen(),
        '/stats': (context) => const StatsScreen(),
        '/detail': (context) => const TransactionDetailScreen(transactionId: '1'), // Placeholder, actual ID will be passed via onGenerateRoute
      },
      onGenerateRoute: (settings){
        if(settings.name != null && settings.name!.startsWith("/transaction/")){
          final id = settings.name!.replaceFirst("/transaction/", "");
          return MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(transactionId: id),
          );
        }
        return null;
      }
    );
  }
}