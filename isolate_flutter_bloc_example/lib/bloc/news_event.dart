part of 'news_bloc.dart';

abstract class NewsEvent {}

class GetNews extends NewsEvent {
  final String data;

  GetNews({required this.data});
}
