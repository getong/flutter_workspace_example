import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'transform_catalog.dart';

class TransformDetailPage extends StatelessWidget {
  const TransformDetailPage({required this.page, super.key});

  final TransformPageSpec page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Text(
              'Dynamic route: /transforms/${page.slug}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(page.message, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Container(
              height: 320,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: page.color.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: page.color, width: 2),
              ),
              child: _buildPreview(page.kind),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(page.message)));
        },
        child: Icon(page.icon),
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () =>
              Navigator.of(context).popUntil((Route<dynamic> route) {
                return route.isFirst;
              }),
          icon: const Icon(Icons.home),
          label: const Text('Back Home'),
        ),
      ],
    );
  }

  Widget _buildPreview(TransformKind kind) {
    switch (kind) {
      case TransformKind.rotate:
        return _buildRotatePreview();
      case TransformKind.scale:
        return _buildScalePreview();
      case TransformKind.translate:
        return _buildTranslatePreview();
      case TransformKind.skew:
        return _buildSkewPreview();
      case TransformKind.matrix:
        return _buildMatrixPreview();
    }
  }

  Widget _buildRotatePreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Transform.rotate(
          angle: -math.pi / 14,
          child: _previewBlock('A', Colors.deepOrange.shade300),
        ),
        Transform.rotate(
          angle: math.pi / 8,
          alignment: Alignment.topLeft,
          child: _previewBlock('B', Colors.deepOrange.shade500),
        ),
        Transform.rotate(
          angle: math.pi / 20,
          alignment: Alignment.bottomRight,
          child: _previewBlock('C', Colors.deepOrange.shade700),
        ),
      ],
    );
  }

  Widget _buildScalePreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Transform.scale(
          scale: 0.75,
          child: _previewBlock('0.75x', Colors.green.shade300),
        ),
        Transform.scale(
          scale: 1.0,
          child: _previewBlock('1.0x', Colors.green.shade500),
        ),
        Transform.scale(
          scale: 1.25,
          alignment: Alignment.bottomCenter,
          child: _previewBlock('1.25x', Colors.green.shade700),
        ),
      ],
    );
  }

  Widget _buildTranslatePreview() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 220,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade300),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: const Text('Original layout box'),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: const Offset(-48, -38),
            child: _floatingTag('(-48, -38)', Colors.blue.shade400),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: const Offset(56, 44),
            child: _floatingTag('(56, 44)', Colors.blue.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildSkewPreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _previewBlock('Normal', Colors.purple.shade400),
        Transform(
          alignment: Alignment.center,
          transform: _skewMatrixX(0.35),
          child: _previewBlock('skewX', Colors.purple.shade600),
        ),
        Transform(
          alignment: Alignment.center,
          transform: _skewMatrixY(0.35),
          child: _previewBlock('skewY', Colors.purple.shade800),
        ),
      ],
    );
  }

  Widget _buildMatrixPreview() {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(-0.35)
          ..rotateY(0.45)
          ..translateByDouble(10.0, -6.0, 0.0, 1.0),
        child: Container(
          width: 190,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: <Color>[Colors.teal.shade300, Colors.teal.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(2, 8),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.view_in_ar, color: Colors.white, size: 34),
              SizedBox(height: 8),
              Text(
                'Matrix4',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewBlock(String label, Color color) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _floatingTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Matrix4 _skewMatrixX(double angle) {
    return Matrix4.identity()..setEntry(0, 1, math.tan(angle));
  }

  Matrix4 _skewMatrixY(double angle) {
    return Matrix4.identity()..setEntry(1, 0, math.tan(angle));
  }
}
