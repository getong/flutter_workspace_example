import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String _countriesQuery = r'''
  query Countries($page: Int!, $search: String, $continent: String) {
    countriesConnection(
      page: $page
      filter: { search: $search, continent: $continent }
    ) {
      info {
        count
        pages
        next
      }
      results {
        code
        name
        emoji
        capital
        currency
        continent
      }
    }
  }
''';

const String _summaryQuery = r'''
  query CountriesSummary($search: String, $continent: String) {
    countriesConnection(
      page: 1
      filter: { search: $search, continent: $continent }
    ) {
      info {
        count
      }
      results {
        code
        name
        capital
      }
    }
  }
''';

const List<_CountryRecord> _allCountries = <_CountryRecord>[
  _CountryRecord(
    code: 'AR',
    name: 'Argentina',
    emoji: 'AR',
    capital: 'Buenos Aires',
    currency: 'ARS',
    continent: 'South America',
  ),
  _CountryRecord(
    code: 'AU',
    name: 'Australia',
    emoji: 'AU',
    capital: 'Canberra',
    currency: 'AUD',
    continent: 'Oceania',
  ),
  _CountryRecord(
    code: 'BR',
    name: 'Brazil',
    emoji: 'BR',
    capital: 'Brasilia',
    currency: 'BRL',
    continent: 'South America',
  ),
  _CountryRecord(
    code: 'CA',
    name: 'Canada',
    emoji: 'CA',
    capital: 'Ottawa',
    currency: 'CAD',
    continent: 'North America',
  ),
  _CountryRecord(
    code: 'CN',
    name: 'China',
    emoji: 'CN',
    capital: 'Beijing',
    currency: 'CNY',
    continent: 'Asia',
  ),
  _CountryRecord(
    code: 'DE',
    name: 'Germany',
    emoji: 'DE',
    capital: 'Berlin',
    currency: 'EUR',
    continent: 'Europe',
  ),
  _CountryRecord(
    code: 'EG',
    name: 'Egypt',
    emoji: 'EG',
    capital: 'Cairo',
    currency: 'EGP',
    continent: 'Africa',
  ),
  _CountryRecord(
    code: 'ES',
    name: 'Spain',
    emoji: 'ES',
    capital: 'Madrid',
    currency: 'EUR',
    continent: 'Europe',
  ),
  _CountryRecord(
    code: 'FR',
    name: 'France',
    emoji: 'FR',
    capital: 'Paris',
    currency: 'EUR',
    continent: 'Europe',
  ),
  _CountryRecord(
    code: 'GH',
    name: 'Ghana',
    emoji: 'GH',
    capital: 'Accra',
    currency: 'GHS',
    continent: 'Africa',
  ),
  _CountryRecord(
    code: 'IN',
    name: 'India',
    emoji: 'IN',
    capital: 'New Delhi',
    currency: 'INR',
    continent: 'Asia',
  ),
  _CountryRecord(
    code: 'JP',
    name: 'Japan',
    emoji: 'JP',
    capital: 'Tokyo',
    currency: 'JPY',
    continent: 'Asia',
  ),
  _CountryRecord(
    code: 'KE',
    name: 'Kenya',
    emoji: 'KE',
    capital: 'Nairobi',
    currency: 'KES',
    continent: 'Africa',
  ),
  _CountryRecord(
    code: 'MX',
    name: 'Mexico',
    emoji: 'MX',
    capital: 'Mexico City',
    currency: 'MXN',
    continent: 'North America',
  ),
  _CountryRecord(
    code: 'NZ',
    name: 'New Zealand',
    emoji: 'NZ',
    capital: 'Wellington',
    currency: 'NZD',
    continent: 'Oceania',
  ),
  _CountryRecord(
    code: 'SG',
    name: 'Singapore',
    emoji: 'SG',
    capital: 'Singapore',
    currency: 'SGD',
    continent: 'Asia',
  ),
  _CountryRecord(
    code: 'US',
    name: 'United States',
    emoji: 'US',
    capital: 'Washington, D.C.',
    currency: 'USD',
    continent: 'North America',
  ),
  _CountryRecord(
    code: 'ZA',
    name: 'South Africa',
    emoji: 'ZA',
    capital: 'Pretoria',
    currency: 'ZAR',
    continent: 'Africa',
  ),
];

const List<String> _continents = <String>[
  'All',
  'Africa',
  'Asia',
  'Europe',
  'North America',
  'Oceania',
  'South America',
];

const int _pageSize = 6;

@RoutePage(name: 'GraphqlFlutterRoute')
class GraphqlFlutterPage extends StatefulWidget {
  const GraphqlFlutterPage({super.key});

  @override
  State<GraphqlFlutterPage> createState() => _GraphqlFlutterPageState();
}

class _GraphqlFlutterPageState extends State<GraphqlFlutterPage> {
  late final ValueNotifier<GraphQLClient> _client;
  late final TextEditingController _searchController;

  String _searchText = 'a';
  String _selectedContinent = 'All';
  bool _runningManualQuery = false;
  String _manualQuerySummary =
      'Tap "Run client.query" to execute a one-off GraphQL request.';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _searchText);
    _client = ValueNotifier<GraphQLClient>(_createClient());
  }

  @override
  void dispose() {
    _client.dispose();
    _searchController.dispose();
    super.dispose();
  }

  GraphQLClient _createClient() {
    return GraphQLClient(
      link: Link.function(_mockCountriesLink),
      cache: GraphQLCache(store: InMemoryStore()),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.all,
        ),
        watchQuery: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.all,
        ),
      ),
    );
  }

  Stream<Response> _mockCountriesLink(
    Request request, [
    NextLink? forward,
  ]) async* {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    final Map<String, dynamic> variables = Map<String, dynamic>.from(
      request.variables,
    );
    final int page = (variables['page'] as int?) ?? 1;
    final String search = (variables['search'] as String? ?? '').trim();
    final String continent = (variables['continent'] as String? ?? '').trim();

    final List<_CountryRecord> filtered = _allCountries.where((
      _CountryRecord country,
    ) {
      final bool matchesSearch =
          search.isEmpty ||
          country.name.toLowerCase().contains(search.toLowerCase()) ||
          country.capital.toLowerCase().contains(search.toLowerCase()) ||
          country.code.toLowerCase().contains(search.toLowerCase());
      final bool matchesContinent =
          continent.isEmpty || country.continent == continent;
      return matchesSearch && matchesContinent;
    }).toList();

    final int totalPages = filtered.isEmpty
        ? 1
        : (filtered.length / _pageSize).ceil();
    final int safePage = page.clamp(1, totalPages);
    final int startIndex = (safePage - 1) * _pageSize;
    final int endIndex = (startIndex + _pageSize).clamp(0, filtered.length);
    final List<_CountryRecord> slice = startIndex >= filtered.length
        ? const <_CountryRecord>[]
        : filtered.sublist(startIndex, endIndex);

    yield Response(
      data: <String, dynamic>{
        '__typename': 'Query',
        'countriesConnection': <String, dynamic>{
          '__typename': 'CountriesConnection',
          'info': <String, dynamic>{
            '__typename': 'Info',
            'count': filtered.length,
            'pages': totalPages,
            'next': safePage < totalPages ? safePage + 1 : null,
          },
          'results': slice
              .map((_CountryRecord country) => country.toMap())
              .toList(),
        },
      },
      response: <String, dynamic>{'source': 'mock-graphql-link'},
    );
  }

  Map<String, dynamic> _variablesForPage(int page) {
    return <String, dynamic>{
      'page': page,
      'search': _searchText.trim().isEmpty ? null : _searchText.trim(),
      'continent': _selectedContinent == 'All' ? null : _selectedContinent,
    };
  }

  Future<void> _runManualQuery(GraphQLClient client) async {
    setState(() {
      _runningManualQuery = true;
      _manualQuerySummary =
          'Running client.query with the current variables...';
    });

    final QueryResult<dynamic> result = await client.query(
      QueryOptions<dynamic>(
        document: gql(_summaryQuery),
        variables: _variablesForPage(1),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result.hasException) {
      setState(() {
        _runningManualQuery = false;
        _manualQuerySummary =
            'Manual query failed: ${_describeOperationException(result.exception)}';
      });
      return;
    }

    final Map<String, dynamic> connection =
        (result.data?['countriesConnection'] as Map?)
            ?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final Map<String, dynamic> info =
        (connection['info'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final List<dynamic> results =
        (connection['results'] as List<dynamic>?) ?? <dynamic>[];
    final List<String> names = results
        .take(3)
        .map((dynamic item) => (item as Map)['name'] as String? ?? 'Unknown')
        .toList();

    setState(() {
      _runningManualQuery = false;
      _manualQuerySummary =
          'client.query loaded ${info['count'] ?? 0} matching countries. '
          'Sample results: ${names.isEmpty ? 'none' : names.join(', ')}.';
    });
  }

  Future<void> _resetClientCache() async {
    setState(() {
      _manualQuerySummary = 'Resetting the in-memory GraphQL cache...';
    });
    _client.value = _createClient();
    if (!mounted) {
      return;
    }
    setState(() {
      _manualQuerySummary =
          'The in-memory GraphQL cache was cleared. The next query will be rebuilt from the mock link.';
    });
  }

  String _describeOperationException(OperationException? exception) {
    if (exception == null) {
      return 'Unknown GraphQL error.';
    }
    final String? linkMessage = exception.linkException?.toString();
    if (linkMessage != null && linkMessage.isNotEmpty) {
      return linkMessage;
    }
    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors
          .map((GraphQLError error) => error.message)
          .join(', ');
    }
    return exception.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: _client,
      child: Scaffold(
        appBar: AppBar(title: const Text('graphql_flutter Module')),
        body: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              const Text(
                'graphql_flutter combines GraphQLClient setup, inherited client access, and Flutter-first widgets such as Query and GraphQLConsumer.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'This module uses an embedded mock GraphQL link so the examples remain stable offline while still demonstrating provider setup, variables, client.query, refetch, fetchMore, and cache behavior.',
              ),
              const SizedBox(height: 20),
              const _GraphqlExampleCard(
                title: 'Client Setup',
                description:
                    'Create a GraphQLClient with a Link and GraphQLCache, then expose it with GraphQLProvider so Query and GraphQLConsumer can access it lower in the widget tree.',
                child: _CodeBlock(
                  code:
                      "final client = ValueNotifier<GraphQLClient>(\n"
                      "  GraphQLClient(\n"
                      "    link: Link.function(mockCountriesLink),\n"
                      "    cache: GraphQLCache(store: InMemoryStore()),\n"
                      "  ),\n"
                      ");\n"
                      "\n"
                      "return GraphQLProvider(\n"
                      "  client: client,\n"
                      "  child: MyApp(),\n"
                      ");",
                ),
              ),
              const SizedBox(height: 16),
              _GraphqlExampleCard(
                title: 'Live Query Controls',
                description:
                    'Update GraphQL variables locally, then let the Query widget request another filtered page from the mock link. This is the same widget flow you use with a real backend.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Country search filter',
                        hintText: 'a, can, tokyo, us...',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedContinent,
                      decoration: const InputDecoration(
                        labelText: 'Continent filter',
                        border: OutlineInputBorder(),
                      ),
                      items: _continents
                          .map(
                            (String continent) => DropdownMenuItem<String>(
                              value: continent,
                              child: Text(continent),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedContinent = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _searchText = _searchController.text;
                            });
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Apply Variables'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _searchController.text = 'an';
                            setState(() {
                              _searchText = 'an';
                              _selectedContinent = 'Europe';
                            });
                          },
                          icon: const Icon(Icons.auto_fix_high),
                          label: const Text('Load Europe Example'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Active variables: ${_variablesForPage(1)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _GraphqlExampleCard(
                title: 'GraphQLConsumer and client.query',
                description:
                    'GraphQLConsumer gives direct access to the nearest GraphQLClient from GraphQLProvider. This is useful for one-off requests outside the Query widget tree.',
                child: GraphQLConsumer(
                  builder: (GraphQLClient client) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            FilledButton.icon(
                              onPressed: _runningManualQuery
                                  ? null
                                  : () => _runManualQuery(client),
                              icon: const Icon(Icons.cloud_download_outlined),
                              label: Text(
                                _runningManualQuery
                                    ? 'Running...'
                                    : 'Run client.query',
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _resetClientCache,
                              icon: const Icon(Icons.layers_clear_outlined),
                              label: const Text('Reset Cache'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(_manualQuerySummary),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _GraphqlExampleCard(
                title: 'Query Widget, Refetch, and Fetch More',
                description:
                    'The Query widget rebuilds whenever graphql_flutter emits a new QueryResult. This example uses refetch for the same variables and fetchMore to append another page.',
                child: Query<dynamic>(
                  options: QueryOptions<dynamic>(
                    document: gql(_countriesQuery),
                    variables: _variablesForPage(1),
                    fetchPolicy: FetchPolicy.cacheAndNetwork,
                  ),
                  builder:
                      (
                        QueryResult<dynamic> result, {
                        Refetch<dynamic>? refetch,
                        FetchMore<dynamic>? fetchMore,
                      }) {
                        if (result.isLoading && result.data == null) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (result.hasException && result.data == null) {
                          return Text(
                            'Query failed: ${_describeOperationException(result.exception)}',
                          );
                        }

                        final Map<String, dynamic> connection =
                            (result.data?['countriesConnection'] as Map?)
                                ?.cast<String, dynamic>() ??
                            <String, dynamic>{};
                        final Map<String, dynamic> info =
                            (connection['info'] as Map?)
                                ?.cast<String, dynamic>() ??
                            <String, dynamic>{};
                        final List<dynamic> items =
                            (connection['results'] as List<dynamic>?) ??
                            <dynamic>[];
                        final int? nextPage = info['next'] as int?;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: <Widget>[
                                FilledButton.icon(
                                  onPressed: refetch == null
                                      ? null
                                      : () => refetch(),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refetch'),
                                ),
                                OutlinedButton.icon(
                                  onPressed:
                                      nextPage == null || fetchMore == null
                                      ? null
                                      : () async {
                                          await fetchMore(
                                            FetchMoreOptions(
                                              variables: _variablesForPage(
                                                nextPage,
                                              ),
                                              updateQuery:
                                                  (
                                                    Map<String, dynamic>?
                                                    previousResultData,
                                                    Map<String, dynamic>?
                                                    fetchMoreResultData,
                                                  ) {
                                                    final List<dynamic>
                                                    previousItems = List<dynamic>.from(
                                                      ((previousResultData?['countriesConnection']
                                                                  as Map?)?['results']
                                                              as List<
                                                                dynamic
                                                              >?) ??
                                                          <dynamic>[],
                                                    );
                                                    final List<dynamic>
                                                    newItems = List<dynamic>.from(
                                                      ((fetchMoreResultData?['countriesConnection']
                                                                  as Map?)?['results']
                                                              as List<
                                                                dynamic
                                                              >?) ??
                                                          <dynamic>[],
                                                    );

                                                    final Map<String, dynamic>
                                                    merged =
                                                        Map<
                                                          String,
                                                          dynamic
                                                        >.from(
                                                          fetchMoreResultData ??
                                                              <
                                                                String,
                                                                dynamic
                                                              >{},
                                                        );
                                                    final Map<String, dynamic>
                                                    mergedConnection =
                                                        Map<
                                                          String,
                                                          dynamic
                                                        >.from(
                                                          (merged['countriesConnection']
                                                                  as Map?) ??
                                                              <
                                                                String,
                                                                dynamic
                                                              >{},
                                                        );

                                                    mergedConnection['results'] =
                                                        <dynamic>[
                                                          ...previousItems,
                                                          ...newItems,
                                                        ];
                                                    merged['countriesConnection'] =
                                                        mergedConnection;
                                                    return merged;
                                                  },
                                            ),
                                          );
                                        },
                                  icon: const Icon(
                                    Icons.add_to_photos_outlined,
                                  ),
                                  label: Text(
                                    nextPage == null
                                        ? 'No More Pages'
                                        : 'Fetch Page $nextPage',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Server count: ${info['count'] ?? 0}, '
                              'pages: ${info['pages'] ?? 0}, '
                              'next page: ${nextPage ?? 'none'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (result.hasException)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  'Partial data arrived with an error: ${_describeOperationException(result.exception)}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            if (items.isEmpty)
                              const Text(
                                'No countries matched the current filter.',
                              )
                            else
                              Column(
                                children: items
                                    .map(
                                      (dynamic item) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: _CountryTile(
                                          item: (item as Map)
                                              .cast<String, dynamic>(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                          ],
                        );
                      },
                ),
              ),
              const SizedBox(height: 16),
              const _GraphqlExampleCard(
                title: 'Common graphql_flutter Patterns',
                description:
                    'Most apps combine these pieces: a shared GraphQLProvider, widgets for watch queries, direct client access for one-off work, and an explicit cache strategy.',
                child: _CodeBlock(
                  code:
                      "Query(\n"
                      "  options: QueryOptions(\n"
                      "    document: gql(readCountries),\n"
                      "    variables: {'page': 1, 'search': 'an'},\n"
                      "    fetchPolicy: FetchPolicy.cacheAndNetwork,\n"
                      "  ),\n"
                      "  builder: (result, {refetch, fetchMore}) {\n"
                      "    if (result.isLoading && result.data == null) {\n"
                      "      return const CircularProgressIndicator();\n"
                      "    }\n"
                      "    return FilledButton(\n"
                      "      onPressed: refetch == null ? null : () => refetch(),\n"
                      "      child: const Text('Refetch'),\n"
                      "    );\n"
                      "  },\n"
                      ");",
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
      ),
    );
  }
}

class _GraphqlExampleCard extends StatelessWidget {
  const _GraphqlExampleCard({
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

class _CountryTile extends StatelessWidget {
  const _CountryTile({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String code = item['code'] as String? ?? '';
    final String name = item['name'] as String? ?? 'Unknown';
    final String capital = item['capital'] as String? ?? 'Unknown';
    final String currency = item['currency'] as String? ?? 'Unknown';
    final String continent = item['continent'] as String? ?? 'Unknown';
    final String emojiCountryCode = item['emoji'] as String? ?? code;

    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueGrey.withValues(alpha: 0.14),
              child: Text(
                _countryCodeToFlag(emojiCountryCode),
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$name ($code)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Capital: $capital'),
                  Text('Currency: $currency'),
                  Text('Continent: $continent'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _countryCodeToFlag(String code) {
    if (code.length != 2) {
      return code;
    }
    final String upper = code.toUpperCase();
    return String.fromCharCodes(
      upper.codeUnits.map((int unit) => unit + 127397),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(code, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _CountryRecord {
  const _CountryRecord({
    required this.code,
    required this.name,
    required this.emoji,
    required this.capital,
    required this.currency,
    required this.continent,
  });

  final String code;
  final String name;
  final String emoji;
  final String capital;
  final String currency;
  final String continent;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '__typename': 'Country',
      'code': code,
      'name': name,
      'emoji': emoji,
      'capital': capital,
      'currency': currency,
      'continent': continent,
    };
  }
}
