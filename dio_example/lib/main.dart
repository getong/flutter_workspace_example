import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MyDioWidget extends StatefulWidget {
  @override
  _MyDioWidgetState createState() => _MyDioWidgetState();
}

class _MyDioWidgetState extends State<MyDioWidget> {
  List<dynamic> _data = [];

  void fetchData() async {
    try {
      var response = await Dio().get('https://www.baidu.com');
      setState(() {
        _data.add(response.data);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Dio Widget'),
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, _index) {
                return ListTile(
                  title: Text(_data[0]),
                  subtitle: Text(_data[0]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: Icon(Icons.refresh),
      ),
    );
  }

  // Add the fetchData method here
}

void main() {
  runApp(MaterialApp(
    title: 'My Dio App',
    home: MyDioWidget(),
  ));
}
