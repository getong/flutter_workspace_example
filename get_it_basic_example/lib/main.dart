import 'package:flutter/material.dart';
import 'package:get_it_basic_example/service_locator.dart';
import 'package:get_it_basic_example/app_model.dart';
import 'package:get_it_basic_example/services/data_repository.dart';
import 'package:get_it_basic_example/services/logger_service.dart';
import 'package:get_it_basic_example/pages/settings_page.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // Access the instance of the registered AppModel
    getIt.isReady<AppModel>().then(
      (_) => getIt<AppModel>().addListener(update),
    );
    super.initState();
  }

  @override
  void dispose() {
    getIt<AppModel>().removeListener(update);
    super.dispose();
  }

  void update() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: getIt.allReady(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('You have pushed the button this many times:'),
                    Text(
                      getIt<AppModel>().counter.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Demonstrate factory pattern - new instance each time
                        final logger = getIt<LoggerService>();
                        logger.log(
                          'Button pressed! Counter: ${getIt<AppModel>().counter}',
                        );
                      },
                      child: const Text('Log Current State'),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<String>>(
                      future: getIt<DataRepository>().getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('Data items: ${snapshot.data!.length}');
                        }
                        return const Text('Loading data...');
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: getIt<AppModel>().incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Waiting for initialisation'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            );
          }
        },
      ),
    );
  }
}
