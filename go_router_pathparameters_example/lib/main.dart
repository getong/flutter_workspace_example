import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

enum AppRoute {
  home,
  product,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        initialLocation: '/',
        debugLogDiagnostics: false,
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomePage(),
            name: AppRoute.home.name,
            routes: [
              GoRoute(
                path: 'product/:id',
                name: AppRoute.product.name,
                builder: (context, state) =>
                    ProductPage(id: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the product page with the ID 123.
            context.goNamed('product', pathParameters: {'id': '123'});
            // GoRouter.of(context).goNamed('product', pathParameters: {'id': '123'});
          },
          child: Text('Go to Product Page'),
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  final String id;

  const ProductPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
      ),
      body: Center(
        child: Text('Product ID: $id'),
      ),
    );
  }
}