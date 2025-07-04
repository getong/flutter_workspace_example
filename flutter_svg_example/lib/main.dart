import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The SVG to display in the example.
const String svgString = '''
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="0 0 166 202">
<defs>
<linearGradient id="triangleGradient">
<stop offset="20%" stop-color="#000000" stop-opacity=".55" />
<stop offset="85%" stop-color="#616161" stop-opacity=".01" />
</linearGradient>
<linearGradient id="rectangleGradient" x1="0%" x2="0%" y1="0%" y2="100%">
<stop offset="20%" stop-color="#000000" stop-opacity=".15" />
<stop offset="85%" stop-color="#616161" stop-opacity=".01" />
</linearGradient>
</defs>
<path fill="#42A5F5" fill-opacity=".8" d="M37.7 128.9 9.8 101 100.4 10.4 156.2 10.4" />
<path fill="#42A5F5" fill-opacity=".8" d="M156.2 94 100.4 94 79.5 114.9 107.4 142.8" />
<path fill="#0D47A1" d="M79.5 170.7 100.4 191.6 156.2 191.6 156.2 191.6 107.4 142.8" />
<g transform="matrix(0.7071, -0.7071, 0.7071, 0.7071, -77.667, 98.057)">
<rect width="39.4" height="39.4" x="59.8" y="123.1" fill="#42A5F5" />
<rect width="39.4" height="5.5" x="59.8" y="162.5" fill="url(#rectangleGradient)" />
</g>
<path d="M79.5 170.7 120.9 156.4 107.4 142.8" fill="url(#triangleGradient)" />
</svg>
''';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: SvgPicture.string(
          svgString,
          width: 500,
          height: 500,
        ),
      ),
    ),
  ));
}
