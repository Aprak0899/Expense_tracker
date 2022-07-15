import 'package:expanse_tracker/expense_screen.dart';
import 'package:expanse_tracker/firebase_options.dart';
import 'package:expanse_tracker/models/transaction_data_bank.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bargraphscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionDataBank>(
      create: (context) => TransactionDataBank(),
      child: MaterialApp(
        initialRoute: "ES",
        routes: {
          "ES": (context) => ExpenseScreen(),
          "BS": (context) => BarChartSample1()
        },
      ),
    );
  }
}
