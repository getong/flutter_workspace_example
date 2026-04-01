import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Table Module')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            'Table arranges widgets into rows and columns with explicit control over borders, alignment, and column sizing.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          _TableExampleCard(
            title: 'Product Comparison',
            description:
                'A basic table with borders and a highlighted header row.',
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.black12),
                outside: BorderSide(color: Colors.black26),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  decoration: BoxDecoration(color: Color(0xFFE3F2FD)),
                  children: <Widget>[
                    _TableCell(text: 'Plan', isHeader: true),
                    _TableCell(text: 'Storage', isHeader: true),
                    _TableCell(text: 'Price', isHeader: true),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    _TableCell(text: 'Starter'),
                    _TableCell(text: '5 GB'),
                    _TableCell(text: '\$0'),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    _TableCell(text: 'Pro'),
                    _TableCell(text: '100 GB'),
                    _TableCell(text: '\$12'),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    _TableCell(text: 'Team'),
                    _TableCell(text: '1 TB'),
                    _TableCell(text: '\$39'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _TableExampleCard(
            title: 'Custom Column Widths',
            description:
                'You can combine fixed, intrinsic, and flex widths to control each column.',
            child: Table(
              border: TableBorder.all(color: Colors.black12),
              columnWidths: <int, TableColumnWidth>{
                0: FixedColumnWidth(96),
                1: FlexColumnWidth(),
                2: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  decoration: BoxDecoration(color: Color(0xFFE8F5E9)),
                  children: <Widget>[
                    _TableCell(text: 'Day', isHeader: true),
                    _TableCell(text: 'Topic', isHeader: true),
                    _TableCell(text: 'Room', isHeader: true),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    _TableCell(text: 'Mon'),
                    _TableCell(text: 'Flutter layout widgets'),
                    _TableCell(text: 'A101'),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    _TableCell(text: 'Tue'),
                    _TableCell(text: 'Responsive design review'),
                    _TableCell(text: 'B204'),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    _TableCell(text: 'Wed'),
                    _TableCell(text: 'State management clinic'),
                    _TableCell(text: 'Lab 3'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _TableExampleCard extends StatelessWidget {
  const _TableExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.text, this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
