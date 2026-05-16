import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.table)
class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Table Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Table arranges widgets into rows and columns with explicit control over borders, alignment, and column sizing.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _TableExampleCard(
              title: 'Product Comparison',
              description:
                  'A basic table with borders and a highlighted header row.',
              code: '''
Table(
  border: TableBorder.symmetric(
    inside: BorderSide(color: Colors.black12),
    outside: BorderSide(color: Colors.black26),
  ),
  children: <TableRow>[
    // rows...
  ],
)
''',
              child: _TablePreview(
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
            ),
            const SizedBox(height: 16),
            _TableExampleCard(
              title: 'defaultColumnWidth: FlexColumnWidth()',
              description:
                  'FlexColumnWidth() is the default behavior. It lets columns share the available horizontal space like Expanded widgets in a Row.',
              code: '''
Table(
  defaultColumnWidth: const FlexColumnWidth(),
  children: <TableRow>[
    // rows...
  ],
)
''',
              child: _TablePreview(
                child: _SizingDemoTable(
                  headerColor: Color(0xFFE8F0FE),
                  defaultColumnWidth: FlexColumnWidth(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TableExampleCard(
              title: 'defaultColumnWidth: FixedColumnWidth(100)',
              description:
                  'FixedColumnWidth(100) forces every column to stay 100 logical pixels wide.',
              code: '''
Table(
  defaultColumnWidth: const FixedColumnWidth(100),
  children: <TableRow>[
    // rows...
  ],
)
''',
              child: _TablePreview(
                child: _SizingDemoTable(
                  headerColor: Color(0xFFFFF3E0),
                  defaultColumnWidth: FixedColumnWidth(100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TableExampleCard(
              title: 'defaultColumnWidth: IntrinsicColumnWidth()',
              description:
                  'IntrinsicColumnWidth() sizes each column to fit its widest cell, which is useful when content length should drive width.',
              code: '''
Table(
  defaultColumnWidth: const IntrinsicColumnWidth(),
  children: <TableRow>[
    // rows...
  ],
)
''',
              child: _TablePreview(
                child: _SizingDemoTable(
                  headerColor: Color(0xFFE8F5E9),
                  defaultColumnWidth: IntrinsicColumnWidth(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _TableExampleCard(
              title: 'defaultColumnWidth: MinColumnWidth(a, b)',
              description:
                  'MinColumnWidth(a, b) picks the smaller result between two column-width rules.',
              code: '''
Table(
  defaultColumnWidth: const MinColumnWidth(
    FixedColumnWidth(140),
    IntrinsicColumnWidth(),
  ),
  children: <TableRow>[
    // rows...
  ],
)
''',
              child: _TablePreview(
                child: _SizingDemoTable(
                  headerColor: Color(0xFFF3E5F5),
                  defaultColumnWidth: MinColumnWidth(
                    FixedColumnWidth(140),
                    IntrinsicColumnWidth(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _TableExampleCard(
              title: 'defaultColumnWidth: MaxColumnWidth(a, b)',
              description:
                  'MaxColumnWidth(a, b) picks the larger result between two column-width rules.',
              code: '''
Table(
  defaultColumnWidth: const MaxColumnWidth(
    FixedColumnWidth(120),
    IntrinsicColumnWidth(),
  ),
  children: <TableRow>[
    // rows...
  ],
)
''',
              child: _TablePreview(
                child: _SizingDemoTable(
                  headerColor: Color(0xFFFFEBEE),
                  defaultColumnWidth: MaxColumnWidth(
                    FixedColumnWidth(120),
                    IntrinsicColumnWidth(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _TableExampleCard(
              title: 'columnWidths: Map<int, TableColumnWidth>',
              description:
                  'Use columnWidths to size each column independently. Here the first column is fixed to 200 logical pixels, while the other columns use different rules.',
              code: '''
Table(
  columnWidths: <int, TableColumnWidth>{
    0: FixedColumnWidth(200),
    1: FlexColumnWidth(),
    2: IntrinsicColumnWidth(),
  },
  children: <TableRow>[
    // rows...
  ],
)
''',
              child: _TablePreview(
                child: Table(
                  border: TableBorder.all(color: Colors.black12),
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(200),
                    1: FlexColumnWidth(),
                    2: IntrinsicColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      decoration: BoxDecoration(color: Color(0xFFE0F7FA)),
                      children: <Widget>[
                        _TableCell(text: 'Session', isHeader: true),
                        _TableCell(text: 'Topic', isHeader: true),
                        _TableCell(text: 'Room', isHeader: true),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        _TableCell(text: 'Morning Workshop'),
                        _TableCell(text: 'Flutter layout widgets'),
                        _TableCell(text: 'A101'),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        _TableCell(text: 'Afternoon Review'),
                        _TableCell(text: 'Responsive design review'),
                        _TableCell(text: 'B204'),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        _TableCell(text: 'Evening Clinic'),
                        _TableCell(text: 'State management clinic'),
                        _TableCell(text: 'Lab 3'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
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
    this.code,
  });

  final String title;
  final String description;
  final Widget child;
  final String? code;

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
            if (code != null) ...<Widget>[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  code!.trim(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _TablePreview extends StatelessWidget {
  const _TablePreview({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: child,
    );
  }
}

class _SizingDemoTable extends StatelessWidget {
  const _SizingDemoTable({
    required this.headerColor,
    required this.defaultColumnWidth,
  });

  final Color headerColor;
  final TableColumnWidth defaultColumnWidth;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black12),
      defaultColumnWidth: defaultColumnWidth,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          decoration: BoxDecoration(color: headerColor),
          children: <Widget>[
            _TableCell(text: 'Role', isHeader: true),
            _TableCell(text: 'Responsibility', isHeader: true),
            _TableCell(text: 'Status', isHeader: true),
          ],
        ),
        TableRow(
          children: <Widget>[
            _TableCell(text: 'Designer'),
            _TableCell(text: 'Review interface spacing'),
            _TableCell(text: 'Ready'),
          ],
        ),
        TableRow(
          children: <Widget>[
            _TableCell(text: 'Developer'),
            _TableCell(text: 'Implement adaptive layout widgets'),
            _TableCell(text: 'In Progress'),
          ],
        ),
        TableRow(
          children: <Widget>[
            _TableCell(text: 'QA'),
            _TableCell(text: 'Verify tablet and phone rendering'),
            _TableCell(text: 'Pending'),
          ],
        ),
      ],
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
