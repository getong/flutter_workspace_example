import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/web3_bloc.dart';
import '../bloc/web3_event.dart';
import '../bloc/web3_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set a default Ethereum address for testing
    _addressController.text = '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<Web3Bloc, Web3State>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Web3 BLoC Example',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<Web3Bloc>().add(ConnectToNetwork());
                  },
                  child: const Text('Connect to Ethereum'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Ethereum Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_addressController.text.isNotEmpty) {
                      context
                          .read<Web3Bloc>()
                          .add(GetBalance(_addressController.text));
                    }
                  },
                  child: const Text('Get Balance'),
                ),
                const SizedBox(height: 20),
                if (state is Web3Loading)
                  const CircularProgressIndicator()
                else if (state is Web3Connected)
                  Text(
                    'Connected to: ${state.networkName}',
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  )
                else if (state is Web3BalanceLoaded)
                  Column(
                    children: [
                      Text(
                        'Address: ${state.address}',
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Balance: ${state.balance} ETH',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                else if (state is Web3Error)
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                else
                  const Text(
                    'Click "Connect to Ethereum" to start',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}
