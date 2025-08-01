import 'package:flutter/material.dart';
import 'screens/wallet_screen_final.dart';
import 'screens/objects_screen_final.dart';
import 'screens/transaction_monitor_final.dart';
import 'services/sui_service_final.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Sui Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SuiHomePage(),
    );
  }
}

class SuiHomePage extends StatefulWidget {
  const SuiHomePage({super.key});

  @override
  State<SuiHomePage> createState() => _SuiHomePageState();
}

class _SuiHomePageState extends State<SuiHomePage> {
  int _selectedIndex = 0;
  final SuiServiceFinal _suiService = SuiServiceFinal(useLocalDevnet: false);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      WalletScreenFinal(suiService: _suiService),
      ObjectsScreenFinal(suiService: _suiService),
      TransactionMonitorFinal(suiService: _suiService),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Explorer',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Monitor'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
