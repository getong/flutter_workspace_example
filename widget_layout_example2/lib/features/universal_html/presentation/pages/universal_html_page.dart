import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/parsing.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.universalHtml)
class UniversalHtmlPage extends StatefulWidget {
  const UniversalHtmlPage({super.key});

  @override
  State<UniversalHtmlPage> createState() => _UniversalHtmlPageState();
}

class _UniversalHtmlPageState extends State<UniversalHtmlPage> {
  late final _HtmlSummary _summary = _buildSummary();

  _HtmlSummary _buildSummary() {
    const String markup = '''
      <html>
        <body>
          <section id="hero">
            <h1 id="hero-title">Universal HTML Demo</h1>
            <p class="lede">Parse and inspect DOM-like structures in Dart.</p>
            <ul class="badges">
              <li class="badge" data-kind="widget">widget</li>
              <li class="badge" data-kind="dom">dom</li>
              <li class="badge" data-kind="parser">parser</li>
            </ul>
          </section>
        </body>
      </html>
    ''';
    const String xml = '''
      <feed>
        <item code="alpha" />
        <item code="beta" />
        <item code="gamma" />
      </feed>
    ''';

    final html.HtmlDocument document = parseHtmlDocument(markup);
    final html.XmlDocument xmlDocument = parseXmlDocument(xml);
    final String title =
        document.querySelector('#hero-title')?.text?.trim() ?? 'Untitled';
    final List<html.Element> badges = document.querySelectorAll('.badge');
    final List<String> badgeKinds = badges
        .map((html.Element element) => element.attributes['data-kind'] ?? '-')
        .toList();

    final html.DivElement runtimeCard = html.DivElement()
      ..className = 'runtime-card'
      ..attributes['data-source'] = 'constructor';
    runtimeCard.append(
      html.AnchorElement(href: 'https://example.com/widgets')
        ..text = 'Open widget docs',
    );
    runtimeCard.append(
      html.DivElement()
        ..text = 'Created with DivElement() and AnchorElement().',
    );

    return _HtmlSummary(
      title: title,
      lede:
          document.querySelector('.lede')?.text?.trim() ??
          'No lead paragraph found.',
      badgeCount: badges.length,
      badgeKinds: badgeKinds,
      runtimeCardHtml: runtimeCard.outerHtml ?? '',
      xmlItemCount: xmlDocument.querySelectorAll('item').length,
      xmlCodes: xmlDocument
          .querySelectorAll('item')
          .map((html.Element element) => element.attributes['code'] ?? '')
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('universal_html Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'universal_html provides browser-like DOM types and parsing helpers across Dart runtimes, which is useful when Flutter needs HTML-flavored document parsing or lightweight DOM manipulation without depending on a real browser environment.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This module demonstrates `parseHtmlDocument`, `parseXmlDocument`, `querySelector`, `querySelectorAll`, `DivElement`, and `AnchorElement` using in-memory markup rather than a live web page.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Parsed HTML Summary',
              description:
                  'The page parses a small HTML snippet and then inspects it with CSS-like selectors the same way browser code would.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _InfoRow(label: 'Title node', value: _summary.title),
                  _InfoRow(label: 'Lead text', value: _summary.lede),
                  _InfoRow(
                    label: 'Badge count',
                    value: _summary.badgeCount.toString(),
                  ),
                  _InfoRow(
                    label: 'Badge kinds',
                    value: _summary.badgeKinds.join(', '),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Runtime DOM Construction',
              description:
                  'Besides parsing text, the package also lets you create DOM-like nodes with element constructors and inspect their serialized output.',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _summary.runtimeCardHtml,
                    style: const TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'XML Parsing',
              description:
                  'The parsing helpers are not limited to HTML. XML content can be queried with the same document model and selector-like access.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _InfoRow(
                    label: 'XML item count',
                    value: _summary.xmlItemCount.toString(),
                  ),
                  _InfoRow(label: 'Codes', value: _summary.xmlCodes.join(', ')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Practical Uses',
              description:
                  'These APIs are especially useful when a Flutter app needs to inspect snippets from CMS content, emails, or imported documents before deciding how to render them.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  _BulletLine(
                    'Parse incoming markup into a queryable document tree.',
                  ),
                  _BulletLine(
                    'Extract headings, links, and metadata with selectors.',
                  ),
                  _BulletLine(
                    'Build DOM-like fragments in memory before serializing them.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyLarge,
          children: <InlineSpan>[
            TextSpan(
              text: '$label: ',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text),
    );
  }
}

class _HtmlSummary {
  const _HtmlSummary({
    required this.title,
    required this.lede,
    required this.badgeCount,
    required this.badgeKinds,
    required this.runtimeCardHtml,
    required this.xmlItemCount,
    required this.xmlCodes,
  });

  final String title;
  final String lede;
  final int badgeCount;
  final List<String> badgeKinds;
  final String runtimeCardHtml;
  final int xmlItemCount;
  final List<String> xmlCodes;
}
