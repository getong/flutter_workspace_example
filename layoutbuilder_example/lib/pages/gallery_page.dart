import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        String layoutInfo;

        if (constraints.maxWidth > 800) {
          crossAxisCount = 4;
          layoutInfo = 'DESKTOP GALLERY (4 columns)';
        } else if (constraints.maxWidth > 500) {
          crossAxisCount = 3;
          layoutInfo = 'TABLET GALLERY (3 columns)';
        } else {
          crossAxisCount = 2;
          layoutInfo = 'MOBILE GALLERY (2 columns)';
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.purple.shade700,
              child: Column(
                children: [
                  Text(
                    '🖼️ $layoutInfo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Width: ${constraints.maxWidth.toInt()}px',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.purple.shade600,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Photo ${index + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
