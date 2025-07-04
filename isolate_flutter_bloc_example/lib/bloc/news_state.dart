part of 'news_bloc.dart';

class NewsState {
  final String myData;

  const NewsState({required this.myData});

  factory NewsState.initial() => const NewsState(myData: "Initial State");

  NewsState copyWith({String? myData}) {
    return NewsState(myData: myData ?? this.myData);
  }
}
