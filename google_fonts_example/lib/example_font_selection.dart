import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExampleFontSelection extends StatefulWidget {
  const ExampleFontSelection({super.key});

  @override
  ExampleFontSelectionState createState() => ExampleFontSelectionState();
}

class ExampleFontSelectionState extends State<ExampleFontSelection> {
  final Iterable<String> fonts = GoogleFonts.asMap().keys;

  final TextEditingController _textEditingController = TextEditingController(
    text: 'abcdefghijklmnopqrstuvwxyz',
  );

  late String _selectedFont;
  late Future _googleFontsPending;

  // Add more example text controllers for different styling examples
  final TextEditingController _headingController = TextEditingController(
    text: 'Heading Example',
  );

  final TextEditingController _bodyController = TextEditingController(
    text:
        'This is a body text example with Google Fonts. It demonstrates how different fonts look in paragraph form.',
  );

  @override
  void initState() {
    _selectedFont = fonts.first;
    _googleFontsPending =
        GoogleFonts.pendingFonts([GoogleFonts.getFont(_selectedFont)]);
    super.initState();
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
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      DropdownMenu<String>(
                        menuHeight: 400,
                        initialSelection: _selectedFont,
                        onSelected: (String? newValue) {
                          setState(() {
                            _selectedFont = newValue!;
                            _googleFontsPending = GoogleFonts.pendingFonts(
                              [GoogleFonts.getFont(_selectedFont)],
                            );
                          });
                        },
                        dropdownMenuEntries:
                            GoogleFonts.asMap().keys.map((String font) {
                          return DropdownMenuEntry<String>(
                            label: font,
                            value: font,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Expanded(
                    child: FutureBuilder(
                      future: _googleFontsPending,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox();
                        }

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading example
                              Text(
                                _headingController.text,
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Body text example
                              Text(
                                _bodyController.text,
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 18.0,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Font weight variations
                              Text(
                                'Font Weight Examples:',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Light (300)',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                'Regular (400)',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Medium (500)',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Bold (700)',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Text decorations
                              Text(
                                'Text Decoration Examples:',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Underlined Text',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 18.0,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.red,
                                ),
                              ),
                              Text(
                                'Overlined Text',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 18.0,
                                  decoration: TextDecoration.overline,
                                  decorationColor: Colors.orange,
                                ),
                              ),
                              Text(
                                'Line Through Text',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 18.0,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.purple,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Letter spacing and word spacing
                              Text(
                                'Spacing Examples:',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'L E T T E R   S P A C I N G',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 18.0,
                                  letterSpacing: 3.0,
                                ),
                              ),
                              Text(
                                'Tight letter spacing',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 18.0,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Wide word spacing example',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 18.0,
                                  wordSpacing: 8.0,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Color variations
                              Text(
                                'Color Examples:',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Gradient-like color text',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [Colors.blue, Colors.purple],
                                    ).createShader(const Rect.fromLTWH(
                                        0.0, 0.0, 200.0, 70.0)),
                                ),
                              ),
                              Text(
                                'Shadowed text',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                  shadows: [
                                    const Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.grey,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Original alphabet example
                              Text(
                                'Alphabet Sample:',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _textEditingController.text,
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 28.0,
                                ),
                              ),
                              Text(
                                _textEditingController.text.toUpperCase(),
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Numbers and special characters
                              Text(
                                'Numbers & Special Characters:',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '0123456789',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 32.0,
                                ),
                              ),
                              Text(
                                '!@#\$%^&*()_+-=[]{}|;:\'",.<>?',
                                style: GoogleFonts.getFont(
                                  _selectedFont,
                                  fontSize: 24.0,
                                ),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        );
                      },
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
