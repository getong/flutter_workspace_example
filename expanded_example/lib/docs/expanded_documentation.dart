import 'package:flutter/material.dart';

/// Documentation page for the Expanded widget
class ExpandedDocumentationPage extends StatelessWidget {
  const ExpandedDocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expanded Widget Documentation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('EXPANDED WIDGET DOCUMENTATION'),
            const SizedBox(height: 16),

            _buildSectionHeader('OVERVIEW'),
            _buildText(
              'The Expanded widget is a fundamental layout widget in Flutter that allows a child '
              'of a Row, Column, or Flex to expand and fill the available space in the main axis.',
            ),

            _buildSectionHeader('KEY CONCEPTS'),
            _buildSubsection('1. MAIN AXIS vs CROSS AXIS:', [
              '• Row: Main axis = horizontal, Cross axis = vertical',
              '• Column: Main axis = vertical, Cross axis = horizontal',
              '• Expanded only affects the main axis dimension',
            ]),

            _buildSubsection('2. FLEX PROPERTY:', [
              '• Default flex value is 1',
              '• Determines the proportion of available space each Expanded widget receives',
              '• Example: If you have 3 Expanded widgets with flex values [1, 2, 3]:',
              '  - Total flex = 1 + 2 + 3 = 6',
              '  - Widget 1 gets 1/6 of available space',
              '  - Widget 2 gets 2/6 (1/3) of available space',
              '  - Widget 3 gets 3/6 (1/2) of available space',
            ]),

            _buildSubsection('3. FIT PROPERTY:', [
              '• FlexFit.tight (default): Forces child to fill allocated space',
              '• FlexFit.loose: Allows child to be smaller than allocated space',
            ]),

            _buildSectionHeader('COMMON USE CASES'),
            _buildUseCase('1. RESPONSIVE LAYOUTS', '''
Row(
  children: [
    Expanded(child: Text('This text will wrap and fill available space')),
    Icon(Icons.star), // Fixed size
  ],
)'''),

            _buildUseCase('2. EQUAL DISTRIBUTION', '''
Row(
  children: [
    Expanded(child: Container(color: Colors.red)),
    Expanded(child: Container(color: Colors.blue)),
    Expanded(child: Container(color: Colors.green)),
  ],
)'''),

            _buildUseCase('3. PROPORTIONAL SIZING', '''
Column(
  children: [
    Expanded(flex: 1, child: HeaderWidget()),    // 1/4 of space
    Expanded(flex: 2, child: ContentWidget()),   // 2/4 of space
    Expanded(flex: 1, child: FooterWidget()),    // 1/4 of space
  ],
)'''),

            _buildUseCase('4. MIXED FIXED AND FLEXIBLE', '''
Column(
  children: [
    Container(height: 100, child: FixedHeader()),  // Fixed size
    Expanded(child: ScrollableContent()),          // Takes remaining space
    Container(height: 50, child: FixedFooter()),   // Fixed size
  ],
)'''),

            _buildSectionHeader('BEST PRACTICES'),
            _buildBestPractice('1. USE WITH FLEX CONTAINERS:', [
              '• Only use Expanded as direct child of Row, Column, or Flex',
              '• Will throw error if used elsewhere',
            ]),

            _buildBestPractice('2. AVOID OVERFLOW:', [
              '• Expanded prevents overflow by constraining child size',
              '• Use when content might exceed available space',
            ]),

            _buildBestPractice('3. COMBINE WITH SCROLLABLE WIDGETS:', [
              '• Wrap scrollable content in Expanded for proper constraints',
              '• ListView, GridView work well inside Expanded',
            ]),

            _buildBestPractice('4. NESTED LAYOUTS:', [
              '• Can nest Expanded widgets for complex layouts',
              '• Each level of nesting has its own flex calculations',
            ]),

            _buildBestPractice('5. PERFORMANCE CONSIDERATIONS:', [
              '• Expanded is lightweight and efficient',
              '• No performance penalty for using multiple Expanded widgets',
            ]),

            _buildSectionHeader('COMMON MISTAKES'),
            _buildMistake('1. USING EXPANDED OUTSIDE FLEX:', '''
// ❌ WRONG - Will throw error
Container(
  child: Expanded(child: Text('Error')),
)

// ✅ CORRECT
Row(
  children: [
    Expanded(child: Text('Success')),
  ],
)'''),

            _buildMistake('2. FORGETTING ABOUT INTRINSIC DIMENSIONS:', '''
// ❌ May cause layout issues
Row(
  children: [
    Expanded(child: Text('Very long text that might overflow')),
    Expanded(child: Text('Short')),
  ],
)

// ✅ Better approach
Row(
  children: [
    Expanded(
      child: Text(
        'Very long text that will wrap properly',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    ),
    Expanded(child: Text('Short')),
  ],
)'''),

            _buildSectionHeader('ALTERNATIVES TO EXPANDED'),
            _buildAlternative('1. FLEXIBLE:', [
              '• Similar to Expanded but with FlexFit.loose by default',
              '• Child can be smaller than allocated space',
            ]),

            _buildAlternative('2. SPACER:', [
              '• Equivalent to Expanded(child: SizedBox())',
              '• Used to create flexible spacing between widgets',
            ]),

            _buildAlternative('3. FRACTIONALLY SIZED BOX:', [
              '• For percentage-based sizing',
              '• Works outside of Flex containers',
            ]),

            _buildSectionHeader('DEBUGGING TIPS'),
            _buildDebuggingTip('1. USE FLUTTER INSPECTOR:', [
              '• Visualize how space is distributed',
              '• Check flex values and constraints',
            ]),

            _buildDebuggingTip('2. ADD COLORED CONTAINERS:', [
              '• Wrap Expanded children in colored containers',
              '• Helps visualize space allocation during development',
            ]),

            _buildDebuggingTip('3. CHECK CONSOLE WARNINGS:', [
              '• Flutter provides helpful warnings for layout issues',
              '• Pay attention to overflow warnings',
            ]),

            _buildSectionHeader('TESTING RECOMMENDATIONS'),
            _buildTestingTip('1. TEST ON DIFFERENT SCREEN SIZES:', [
              '• Use device preview to test various screen dimensions',
              '• Ensure layout works on both small and large screens',
            ]),

            _buildTestingTip('2. TEST WITH DIFFERENT CONTENT LENGTHS:', [
              '• Test with short and long text content',
              '• Verify overflow handling works correctly',
            ]),

            _buildTestingTip('3. ROTATION TESTING:', [
              '• Test both portrait and landscape orientations',
              '• Ensure flex ratios work in both orientations',
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildSubsection(String title, List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(point, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCase(String title, String code) {
    return _buildCodeSection(title, code, Colors.green);
  }

  Widget _buildMistake(String title, String code) {
    return _buildCodeSection(title, code, Colors.red);
  }

  Widget _buildCodeSection(String title, String code, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestPractice(String title, List<String> points) {
    return _buildPointSection(title, points, Colors.green);
  }

  Widget _buildAlternative(String title, List<String> points) {
    return _buildPointSection(title, points, Colors.orange);
  }

  Widget _buildDebuggingTip(String title, List<String> points) {
    return _buildPointSection(title, points, Colors.purple);
  }

  Widget _buildTestingTip(String title, List<String> points) {
    return _buildPointSection(title, points, Colors.teal);
  }

  Widget _buildPointSection(String title, List<String> points, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(point, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
