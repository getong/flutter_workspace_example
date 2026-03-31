import 'package:flutter/material.dart';

import 'key_demo_shell.dart';

class ObjectKeyDemoPage extends StatefulWidget {
  const ObjectKeyDemoPage({super.key});

  @override
  State<ObjectKeyDemoPage> createState() => _ObjectKeyDemoPageState();
}

class _ObjectKeyDemoPageState extends State<ObjectKeyDemoPage> {
  final List<_Product> _products = <_Product>[
    _Product(name: 'Mechanical Keyboard', price: 129),
    _Product(name: '4K Monitor', price: 399),
    _Product(name: 'USB-C Dock', price: 179),
    _Product(name: 'Noise-Canceling Headphones', price: 249),
  ];

  void _sortByPrice() {
    setState(() {
      _products.sort((a, b) => a.price.compareTo(b.price));
    });
  }

  void _sortByName() {
    setState(() {
      _products.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyDemoShell(
      title: 'ObjectKey Product List',
      description:
          'ObjectKey uses the object instance itself as identity. This is '
          'useful when each row maps directly to a richer domain object.',
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.tonal(
                onPressed: _sortByPrice,
                child: const Text('Sort by price'),
              ),
              OutlinedButton(
                onPressed: _sortByName,
                child: const Text('Sort by name'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (BuildContext context, int index) {
                  final _Product product = _products[index];
                  return SwitchListTile(
                    key: ObjectKey(product),
                    value: product.isFeatured,
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(0)}'),
                    secondary: const Icon(Icons.shopping_bag_outlined),
                    onChanged: (bool value) {
                      setState(() {
                        product.isFeatured = value;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Product {
  _Product({required this.name, required this.price, this.isFeatured = false});

  final String name;
  final double price;
  bool isFeatured;
}
