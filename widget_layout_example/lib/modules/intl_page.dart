import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class IntlPage extends StatelessWidget {
  const IntlPage({super.key});

  @override
  Widget build(BuildContext context) {
    const client = _Client(
      name: 'Acme Logistics',
      contractSize: 275000.5,
      contactEmail: 'ops@acme-logistics.com',
      contactPhone: '+1 (415) 555-0188',
    );

    final details = <MapEntry<String, String>>[
      MapEntry("Client Name", client.name),
      MapEntry(
        "Contract Size",
        NumberFormat.simpleCurrency(
          locale: "en_US",
        ).format(client.contractSize),
      ),
      MapEntry("Contact Email", client.contactEmail),
      MapEntry("Contact Phone", client.contactPhone),
    ];

    final rawContractSize = client.contractSize.toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Intl Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'The intl package helps present locale-aware values. Currency formatting is a common need because raw numbers are harder to read and lack the correct symbol grouping.',
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
                    Text(
                      'Currency Formatting',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Raw value: $rawContractSize'),
                    const SizedBox(height: 8),
                    Text(
                      'Formatted value: ${NumberFormat.simpleCurrency(locale: "en_US").format(client.contractSize)}',
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
                    Text(
                      'Client Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This section uses the MapEntry structure you provided to prepare display-friendly label/value rows.',
                    ),
                    const SizedBox(height: 16),
                    ...details.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 120,
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _Client {
  const _Client({
    required this.name,
    required this.contractSize,
    required this.contactEmail,
    required this.contactPhone,
  });

  final String name;
  final double contractSize;
  final String contactEmail;
  final String contactPhone;
}
