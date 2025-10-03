import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import '../Controller/TransactionController.dart';

class HomeScreen extends StatelessWidget {

  HomeScreen({super.key});
  //apri lo storage hive
  final box = Hive.box('storage');
  //controller
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
                'Welcome to Personal Finance Tracker!',
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
          final balanceFont = width < 400 ? 18.0 : width < 700 ? 22.0 : 28.0;
          final amountFont = width < 400 ? 24.0 : width < 700 ? 32.0 : 40.0;
          final chartHeight = width < 400 ? 120.0 : width < 700 ? 180.0 : 250.0;
          final buttonPadding = width < 400 ? EdgeInsets.symmetric(horizontal: 12, vertical: 8) : EdgeInsets.symmetric(horizontal: 24, vertical: 12);
          // Layout responsive: desktop (>1000), tablet (700-1000), mobile (<700)
          // Margini laterali responsive
          final horizontalPadding = width < 700 ? 32.0 : width < 1000 ? 48.0 : 64.0;
          return width > 1000
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [ // desktop
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [ // saldo e bottoni
                                Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your total balance',
                                      style: TextStyle(fontSize: balanceFont, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '€${transactionController.total.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: amountFont, color: Colors.green, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    const SizedBox(width: 16),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          height: chartHeight,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              'Portfolio Trend Chart Here',
                              style: TextStyle(fontSize: balanceFont, color: Colors.blueGrey[700]),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : width > 700
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [ // tablet
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your total balance',
                                          style: TextStyle(fontSize: balanceFont, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '€${transactionController.total.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: amountFont, color: Colors.green, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                                    const SizedBox(height: 32),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
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
                                        const SizedBox(width: 16),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              height: chartHeight,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'Portfolio Trend Chart Here',
                                  style: TextStyle(fontSize: balanceFont, color: Colors.blueGrey[700]),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [ // mobile
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Your total balance',
                                          style: TextStyle(fontSize: balanceFont, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '€${transactionController.total.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: amountFont, color: Colors.green, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                                    const SizedBox(height: 32),
                                    Column(
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              height: chartHeight,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'Portfolio Trend Chart Here',
                                  style: TextStyle(fontSize: balanceFont, color: Colors.blueGrey[700]),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}

