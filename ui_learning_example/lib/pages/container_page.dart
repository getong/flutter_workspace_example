import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.home.path);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Container Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Examples with image, linear gradient, and radial gradient.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('1) Container with Image'),
            const SizedBox(height: 10),
            Container(
              height: 180,
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: const DecorationImage(
                  image: NetworkImage('https://picsum.photos/900/500'),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'Image Decoration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('2) Container with LinearGradient'),
            const SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF155799),
                    Color(0xFF159957),
                    Color(0xFFF6D365),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
              child: const Text(
                'LinearGradient',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('3) Container with RadialGradient'),
            const SizedBox(height: 10),
            Container(
              height: 180,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const RadialGradient(
                  center: Alignment(-0.35, -0.35),
                  radius: 1.1,
                  focal: Alignment(0.6, 0.55),
                  focalRadius: 0.08,
                  colors: [
                    Color(0xFFFFF4D6),
                    Color(0xFFFF9A9E),
                    Color(0xFF3A1C71),
                  ],
                  stops: [0.1, 0.55, 1.0],
                ),
              ),
              child: const Text(
                'RadialGradient',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('4) Container with RadialGradient 2'),
            const SizedBox(height: 10),
            Container(
              height: 360,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                gradient: RadialGradient(
                  radius: 0.15,
                  center: Alignment(0, 0),
                  tileMode: TileMode.mirror,
                  colors: [Colors.blue, Colors.deepPurple, Colors.lightBlue],
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('5) Container with LinearGradient'),
            const SizedBox(height: 10),
            Container(
              height: 360,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                gradient: LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, -0.4),
                  tileMode: TileMode.mirror,
                  colors: [Colors.blue, Colors.orange],
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('6) Container with Gradients'),
            const SizedBox(height: 10),
            Container(
              height: 360,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.orange],
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('7) Container with image'),
            const SizedBox(height: 10),
            Container(
              width: 450,
              height: 900,
              margin: const EdgeInsets.all(100),
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.elliptical(50, 50),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.elliptical(25, 25),
                ),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.6),
                    BlendMode.dstATop,
                  ),
                  image: const AssetImage('images/idea-1873540_640.png'),
                  repeat: ImageRepeat.repeatY,
                ),
              ),
              child: const Text('Container'),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('8) Container with image'),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(100),
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(50, 50),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.elliptical(25, 25),
                ),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.dstATop,
                  ),
                  image: AssetImage("images/idea-1873540_640.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text('Container'),
            ),
            const SizedBox(height: 26),
            _buildSectionTitle('9) Container with image'),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(100),
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(50, 50),
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.elliptical(25, 25),
                ),
                image: DecorationImage(
                  image: AssetImage("images/idea-1873540_640.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text('Container'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
