import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';

class RowColumnPage extends StatelessWidget {
  const RowColumnPage({super.key});

  List<Widget> boxes(int n, double w, double h) {
    List<Widget> bxs = <Widget>[];
    List fill = [Colors.blue, Colors.green, Colors.purple, Colors.pink];
    for (int i = 0; i <= n - 1; i++) {
      Container bx = Container(
        child: Text(i.toString()),
        color: fill[i],
        width: w,
        height: h,
      );
      bxs.add(bx);
    }
    return bxs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Row & Column Layout'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.home.path);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Row Example:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(height: 50, child: Row(children: boxes(4, 40, 40))),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.star, color: Colors.red, size: 40),
                  Icon(Icons.favorite, color: Colors.pink, size: 40),
                  Icon(Icons.thumb_up, color: Colors.blue, size: 40),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Column Example:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(children: boxes(4, 40, 40)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Colors.green, size: 40),
                  SizedBox(height: 10),
                  Icon(Icons.work, color: Colors.orange, size: 40),
                  SizedBox(height: 10),
                  Icon(Icons.school, color: Colors.purple, size: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
