import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';

class BasicScaffoldPage extends StatelessWidget {
  const BasicScaffoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 26, fontStyle: FontStyle.italic),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter UI Succinctly'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go(AppRoutes.home.path);
            },
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(100),
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            // shape: BoxShape.circle,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topRight: Radius.elliptical(50, 50),
              bottomLeft: Radius.elliptical(25, 25),
            ),
            gradient: RadialGradient(
              radius: 0.15,
              center: Alignment(0, 0),
              tileMode: TileMode.mirror,
              colors: [Colors.blue, Colors.deepPurple, Colors.lightBlue],
            ),
            // gradient: LinearGradient(
            //   // colors: [Colors.blue, Colors.purple],
            //   // begin: Alignment.topLeft,
            //   // end: Alignment.bottomRight,
            //   begin: Alignment(0, -1),
            //   end: Alignment(0, -0.4),
            //   tileMode: TileMode.mirror,
            //   colors: [Colors.blue, Colors.orange],
            // ),
            image: DecorationImage(
              image: NetworkImage('https://picsum.photos/300/300'),
              fit: BoxFit.cover,
            ),
          ),
          width: 300,
          height: 300,
          child: FlutterLogo(size: 100),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.ac_unit),
          onPressed: () {
            print('Oh, it is cold outside...');
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class BasicScaffoldPage extends StatelessWidget {
//   const BasicScaffoldPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Basic Scaffold'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.widgets, size: 100, color: Colors.blue),
//             SizedBox(height: 20),
//             Text(
//               'Basic Scaffold Page',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'This is a basic scaffold implementation',
//               style: TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// }
// }
//           ],
//         ),
//       ),
//     );
//   }
// }
// }
// }
// }
// }
// }
// }
// }
// }
// }
// }
// }
