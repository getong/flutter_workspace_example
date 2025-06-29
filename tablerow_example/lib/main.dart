import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Table and TableRow Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Example 1: Basic Table',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBasicTable(),
            const SizedBox(height: 32),

            const Text(
              'Example 2: Styled Table with Borders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStyledTable(),
            const SizedBox(height: 32),

            const Text(
              'Example 3: Dynamic Table with Different Column Widths',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDynamicTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicTable() {
    return Table(
      children: const [
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Age', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'City',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: Text('John Doe')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('25')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('New York')),
          ],
        ),
        TableRow(
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: Text('Jane Smith')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('30')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('Los Angeles')),
          ],
        ),
        TableRow(
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: Text('Bob Johnson')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('35')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('Chicago')),
          ],
        ),
      ],
    );
  }

  Widget _buildStyledTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: Colors.blue),
            children: const [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Stock',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade50),
            children: const [
              Padding(padding: EdgeInsets.all(12.0), child: Text('Laptop')),
              Padding(padding: EdgeInsets.all(12.0), child: Text('\$999')),
              Padding(padding: EdgeInsets.all(12.0), child: Text('15')),
            ],
          ),
          const TableRow(
            children: [
              Padding(padding: EdgeInsets.all(12.0), child: Text('Mouse')),
              Padding(padding: EdgeInsets.all(12.0), child: Text('\$29')),
              Padding(padding: EdgeInsets.all(12.0), child: Text('50')),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade50),
            children: const [
              Padding(padding: EdgeInsets.all(12.0), child: Text('Keyboard')),
              Padding(padding: EdgeInsets.all(12.0), child: Text('\$79')),
              Padding(padding: EdgeInsets.all(12.0), child: Text('25')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.purple.shade200, width: 2),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.purple.shade100),
          children: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Course Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Duration',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Instructor',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Rating',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Flutter Development'),
            ),
            Padding(padding: EdgeInsets.all(10.0), child: Text('8 weeks')),
            Padding(padding: EdgeInsets.all(10.0), child: Text('Dr. Smith')),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' 4.8'),
                ],
              ),
            ),
          ],
        ),
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('React Native Basics'),
            ),
            Padding(padding: EdgeInsets.all(10.0), child: Text('6 weeks')),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Prof. Johnson'),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' 4.5'),
                ],
              ),
            ),
          ],
        ),
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Web Development with Dart'),
            ),
            Padding(padding: EdgeInsets.all(10.0), child: Text('10 weeks')),
            Padding(padding: EdgeInsets.all(10.0), child: Text('Ms. Williams')),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' 4.9'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
