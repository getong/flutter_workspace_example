import 'package:flutter/material.dart';

class OrderCompletedScreen extends StatelessWidget {
  const OrderCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Completed')),
      body: const Center(child: Text('Order has been completed successfully!')),
    );
  }
}
