import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'message.pb.dart'; // Import the generated protobuf classes

// Events
abstract class ProtobufEvent {}

class SendProtobufDataEvent extends ProtobufEvent {}

// States
abstract class ProtobufState {}

class ProtobufInitialState extends ProtobufState {}

class ProtobufSuccessState extends ProtobufState {
  final String response;

  ProtobufSuccessState(this.response);
}

class ProtobufErrorState extends ProtobufState {
  final String error;

  ProtobufErrorState(this.error);
}

// BLoC
class ProtobufBloc extends Bloc<ProtobufEvent, ProtobufState> {
  ProtobufBloc() : super(ProtobufInitialState()) {
    on<SendProtobufDataEvent>(_mapSendProtobufDataEventToState);
  }

  Stream<ProtobufState> _mapSendProtobufDataEventToState(
    SendProtobufDataEvent event, Emitter<ProtobufState> emit) async* {
    emit(ProtobufInitialState()); // Optional: emit loading state

    try {
      Dio dio = Dio();
      MyMessage message = MyMessage()
      ..name = 'John Doe'
      ..age = 30;

      // Serialize the protobuf message to a list of bytes
      List<int> messageBytes = message.writeToBuffer();

      // Send the protobuf data using Dio
      FormData formData = FormData.fromMap({
          'protobuf_data': MultipartFile.fromBytes(
            messageBytes,
            filename: 'message.bin',
          ),
      });

      Response response = await dio.post(
        'http://localhost:8080', // Replace with your server endpoint
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      emit(ProtobufSuccessState(response.data.toString()));
    } catch (error) {
      // Handle errors here
      emit(ProtobufErrorState(error.toString()));
    }
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Protobuf BLoC Example',
      home: BlocProvider(
        create: (context) => ProtobufBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dio Protobuf BLoC Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<ProtobufBloc>(context).add(SendProtobufDataEvent());
              },
              child: Text('Send Protobuf Data'),
            ),
            SizedBox(height: 20),
            BlocBuilder<ProtobufBloc, ProtobufState>(
              builder: (context, state) {
                if (state is ProtobufInitialState) {
                  return Text('Press the button to send Protobuf data.');
                } else if (state is ProtobufSuccessState) {
                  return Text('Response: ${state.response}');
                } else if (state is ProtobufErrorState) {
                  return Text('Error: ${state.error}');
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio.dart';
// import 'message.pb.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // Import the generated protobuf classes


// // Events
// abstract class ProtobufEvent {}

// class SendProtobufDataEvent extends ProtobufEvent {}

// // States
// abstract class ProtobufState {}

// class ProtobufInitialState extends ProtobufState {}

// class ProtobufSuccessState extends ProtobufState {
//   final String response;

//   ProtobufSuccessState(this.response);
// }

// class ProtobufErrorState extends ProtobufState {
//   final String error;

//   ProtobufErrorState(this.error);
// }

// // BLoC
// class ProtobufBloc extends Bloc<ProtobufEvent, ProtobufState> {
//   ProtobufBloc() : super(ProtobufInitialState());

//   @override
//   Stream<ProtobufState> mapEventToState(ProtobufEvent event) async* {
//     if (event is SendProtobufDataEvent) {
//       try {
//         Dio dio = Dio();
//         MyMessage message = MyMessage()
//         ..name = 'John Doe'
//         ..age = 30;

//         // Serialize the protobuf message to a list of bytes
//         List<int> messageBytes = message.writeToBuffer();

//         // Send the protobuf data using Dio
//         FormData formData = FormData.fromMap({
//             'protobuf_data': MultipartFile.fromBytes(
//               messageBytes,
//               filename: 'message.bin',
//             ),
//         });

//         Response response = await dio.post(
//           'http://localhost:8080', // Replace with your server endpoint
//           data: formData,
//           options: Options(
//             headers: {
//               'Content-Type': 'multipart/form-data',
//             },
//           ),
//         );

//         yield ProtobufSuccessState(response.data.toString());
//       } catch (error) {
//         // Handle errors here
//         yield ProtobufErrorState(error.toString());
//       }
//     }
//   }
// }

// // Widget
// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dio Protobuf BLoC Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 BlocProvider.of<ProtobufBloc>(context).add(SendProtobufDataEvent());
//               },
//               child: Text('Send Protobuf Data'),
//             ),
//             SizedBox(height: 20),
//             BlocBuilder<ProtobufBloc, ProtobufState>(
//               builder: (context, state) {
//                 if (state is ProtobufInitialState) {
//                   return Text('Press the button to send Protobuf data.');
//                 } else if (state is ProtobufSuccessState) {
//                   return Text('Response: ${state.response}');
//                 } else if (state is ProtobufErrorState) {
//                   return Text('Error: ${state.error}');
//                 }
//                 return Container();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Dio Protobuf BLoC Example',
//       home: BlocProvider(
//         create: (context) => ProtobufBloc(),
//         child: MyHomePage(),
//       ),
//     );
//   }
// }