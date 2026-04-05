import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  GoRouter.optionURLReflectsImperativeAPIs = true;
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
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the product page with the ID 123.
                context.goNamed('product', pathParameters: {'id': '1'});
                // GoRouter.of(context).goNamed('product', pathParameters: {'id': '123'});
              },
              child: Text('Go to Product Page'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the product page with the ID 123.
                context.pushNamed('product', pathParameters: {'id': '12'});
                // GoRouter.of(context).goNamed('product', pathParameters: {'id': '123'});
              },
              child: Text('push to Product Page'),
            ),
          ],
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
          child: Column(
        children: <Widget>[
          Text('Product ID: $id'),
          ElevatedButton(
            onPressed: () {
              // Navigate to the product page with the ID 123.
              context.goNamed('product', pathParameters: {'id': '4'});
              // GoRouter.of(context).goNamed('product', pathParameters: {'id': '123'});
            },
            child: Text('Go to Product Page'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the product page with the ID 123.
              context.pushNamed('product', pathParameters: {'id': '5'});
              // GoRouter.of(context).goNamed('product', pathParameters: {'id': '123'});
            },
            child: Text('push to Product Page'),
          ),
        ],
      )),
    );
  }
}
