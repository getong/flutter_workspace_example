import 'package:flutter/material.dart';

import 'offline_fonts.dart';

class ExampleFontSelection extends StatefulWidget {
  const ExampleFontSelection({super.key});

  @override
  ExampleFontSelectionState createState() => ExampleFontSelectionState();
}

class ExampleFontSelectionState extends State<ExampleFontSelection> {
  final List<DemoFontOption> _fontOptions = demoFontOptions;

  final TextEditingController _textEditingController = TextEditingController(
    text: 'abcdefghijklmnopqrstuvwxyz',
  );

  late DemoFontOption _selectedFont;

  final TextEditingController _headingController = TextEditingController(
    text: 'Heading Example',
  );

  final TextEditingController _bodyController = TextEditingController(
    text:
        'This is a body text example with Google Fonts. It demonstrates how different fonts look in paragraph form.',
  );

  @override
  void initState() {
    super.initState();
    _selectedFont = _fontOptions.first;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _headingController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      SizedBox(
                        width: 360,
                        child: TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Preview text',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      DropdownMenu<String>(
                        menuHeight: 400,
                        initialSelection: _selectedFont.label,
                        onSelected: (String? newValue) {
                          if (newValue == null) {
                            return;
                          }
                          setState(() {
                            _selectedFont = demoFontByLabel(newValue);
                          });
                        },
                        dropdownMenuEntries:
                            _fontOptions.map((DemoFontOption option) {
                          return DropdownMenuEntry<String>(
                            label: option.label,
                            value: option.label,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _headingController.text,
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _bodyController.text,
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Font Weight Examples:',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Light (300)',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'Regular (400)',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Medium (500)',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Bold (700)',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Text Decoration Examples:',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Underlined Text',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 18.0,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                            ),
                          ),
                          Text(
                            'Overlined Text',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 18.0,
                              decoration: TextDecoration.overline,
                              decorationColor: Colors.orange,
                            ),
                          ),
                          Text(
                            'Line Through Text',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.purple,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Spacing Examples:',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'L E T T E R   S P A C I N G',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 18.0,
                              letterSpacing: 3.0,
                            ),
                          ),
                          Text(
                            'Tight letter spacing',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 18.0,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Wide word spacing example',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 18.0,
                              wordSpacing: 8.0,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Color Examples:',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Gradient-like color text',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [Colors.blue, Colors.purple],
                                ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                ),
                            ),
                          ),
                          Text(
                            'Shadowed text',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 20.0,
                              color: Colors.black87,
                              shadows: const <Shadow>[
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.grey,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Alphabet Sample:',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _textEditingController.text,
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 28.0,
                            ),
                          ),
                          Text(
                            _textEditingController.text.toUpperCase(),
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Numbers & Special Characters:',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '0123456789',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 32.0,
                            ),
                          ),
                          Text(
                            '!@#\$%^&*()_+-=[]{}|;:\'",.<>?',
                            style: demoFontStyle(
                              _selectedFont,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bundled fonts work offline. System font entries '
                            'fall back gracefully when unavailable.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
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
