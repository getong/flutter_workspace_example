import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          child: Text('View User 123'),
          onPressed: () {
            context.go(
              AppRoute.userDetails.routeWithParams(params: {'id': '123'}),
            );
          },
        ),
      ),
    );
  }
}
