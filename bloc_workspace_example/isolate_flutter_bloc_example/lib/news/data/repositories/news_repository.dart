import '../../models/news_socket_update.dart';
import '../datasources/news_socket_datasource.dart';

class NewsRepository {
  NewsRepository({required NewsSocketDataSource dataSource})
    : _dataSource = dataSource;

  final NewsSocketDataSource _dataSource;

  Stream<NewsSocketUpdate> get updates => _dataSource.updates;

  Future<void> connect(String url) => _dataSource.connect(url);

  Future<void> disconnect() => _dataSource.disconnect();

  Future<void> sendMessage(String message) => _dataSource.sendMessage(message);

  Future<void> dispose() => _dataSource.dispose();
}
