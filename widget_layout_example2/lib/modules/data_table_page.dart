import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage(name: 'DataTableRoute')
class DataTablePage extends StatefulWidget {
  const DataTablePage({super.key});

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  static const String _sortingExampleCode = '''
DataTable(
  sortColumnIndex: _sortColumnIndex,
  sortAscending: _sortAscending,
  columns: <DataColumn>[
    DataColumn(
      label: const Text('Name'),
      onSort: (int columnIndex, bool ascending) {
        setState(() {
          _sortColumnIndex = columnIndex;
          _sortAscending = ascending;
          _employees.sort(
            (_EmployeeRow a, _EmployeeRow b) => a.name.compareTo(b.name),
          );
          if (!ascending) {
            _employees.replaceRange(0, _employees.length, _employees.reversed);
          }
        });
      },
    ),
  ],
  rows: _employees.map((_EmployeeRow employee) {
    return DataRow(
      cells: <DataCell>[DataCell(Text(employee.name))],
    );
  }).toList(),
)
''';

  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _rowsPerPage = 4;

  final List<_EmployeeRow> _employees = <_EmployeeRow>[
    const _EmployeeRow('Alicia Lee', 'Operations', 92000, true),
    const _EmployeeRow('Marcus Chen', 'Engineering', 118000, false),
    const _EmployeeRow('Priya Patel', 'Finance', 104000, true),
    const _EmployeeRow('Jonah Rivera', 'Design', 96500, true),
  ];

  late final _InventoryDataSource _dataSource = _InventoryDataSource();

  void _sortTable(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      switch (columnIndex) {
        case 0:
          _employees.sort(
            (_EmployeeRow a, _EmployeeRow b) =>
                a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
          break;
        case 1:
          _employees.sort(
            (_EmployeeRow a, _EmployeeRow b) =>
                a.team.toLowerCase().compareTo(b.team.toLowerCase()),
          );
          break;
        case 2:
          _employees.sort(
            (_EmployeeRow a, _EmployeeRow b) => a.salary.compareTo(b.salary),
          );
          break;
        case 3:
          _employees.sort(
            (_EmployeeRow a, _EmployeeRow b) =>
                a.active.toString().compareTo(b.active.toString()),
          );
          break;
      }

      if (!ascending) {
        _employees.replaceRange(0, _employees.length, _employees.reversed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataTable + PaginatedDataTable Module'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'DataTable is useful for small structured datasets, while PaginatedDataTable adds paging controls for larger sets.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(
                    'DataTable Example',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'This example shows sorting across columns in a compact table.',
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      columns: <DataColumn>[
                        DataColumn(
                          label: const Text('Name'),
                          onSort: _sortTable,
                        ),
                        DataColumn(
                          label: const Text('Team'),
                          onSort: _sortTable,
                        ),
                        DataColumn(
                          label: const Text('Salary'),
                          numeric: true,
                          onSort: _sortTable,
                        ),
                        DataColumn(
                          label: const Text('Active'),
                          onSort: _sortTable,
                        ),
                      ],
                      rows: _employees
                          .map(
                            (_EmployeeRow employee) => DataRow(
                              cells: <DataCell>[
                                DataCell(SelectableText(employee.name)),
                                DataCell(SelectableText(employee.team)),
                                DataCell(
                                  SelectableText(employee.formattedSalary),
                                ),
                                DataCell(
                                  Icon(
                                    employee.active
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: employee.active
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(
                    'Sorting DataTables Code Example',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'The key pieces are `sortColumnIndex`, `sortAscending`, and `DataColumn.onSort`. Update the list inside `setState`, then reverse it when descending order is requested.',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      _sortingExampleCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: PaginatedDataTable(
              header: const Text('PaginatedDataTable Example'),
              columns: const <DataColumn>[
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Item')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Stock')),
              ],
              source: _dataSource,
              rowsPerPage: _rowsPerPage,
              availableRowsPerPage: const <int>[4, 6, 8],
              onRowsPerPageChanged: (int? value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _rowsPerPage = value;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _EmployeeRow {
  const _EmployeeRow(this.name, this.team, this.salary, this.active);

  final String name;
  final String team;
  final int salary;
  final bool active;

  String get formattedSalary {
    final String digits = salary.toString();
    final StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      final int reversedIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reversedIndex > 1 && reversedIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return '\$$buffer';
  }
}

class _InventoryDataSource extends DataTableSource {
  final List<_InventoryRow> _rows = const <_InventoryRow>[
    _InventoryRow('INV-1001', 'Keyboard', 'Hardware', 24),
    _InventoryRow('INV-1002', 'Monitor', 'Hardware', 18),
    _InventoryRow('INV-1003', 'Mouse', 'Hardware', 42),
    _InventoryRow('INV-1004', 'Notebook', 'Office', 65),
    _InventoryRow('INV-1005', 'Headset', 'Hardware', 14),
    _InventoryRow('INV-1006', 'Printer Paper', 'Office', 120),
    _InventoryRow('INV-1007', 'USB-C Cable', 'Accessories', 56),
    _InventoryRow('INV-1008', 'Docking Station', 'Accessories', 11),
  ];

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) {
      return null;
    }

    final _InventoryRow row = _rows[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(row.id)),
        DataCell(Text(row.item)),
        DataCell(Text(row.category)),
        DataCell(Text(row.stock.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}

class _InventoryRow {
  const _InventoryRow(this.id, this.item, this.category, this.stock);

  final String id;
  final String item;
  final String category;
  final int stock;
}
