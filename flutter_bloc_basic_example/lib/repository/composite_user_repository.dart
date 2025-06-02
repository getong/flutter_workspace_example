import 'user_repository.dart';
import 'cache_repository.dart';
import 'analytics_repository.dart';

/// {@template composite_user_repository}
/// Repository that combines UserRepository with caching and analytics
/// Demonstrates repository composition with RepositoryProvider
/// {@endtemplate}
class CompositeUserRepository implements UserRepository {
  CompositeUserRepository({
    required UserRepository userRepository,
    required CacheRepository cacheRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _userRepository = userRepository,
        _cacheRepository = cacheRepository,
        _analyticsRepository = analyticsRepository;

  final UserRepository _userRepository;
  final CacheRepository _cacheRepository;
  final AnalyticsRepository _analyticsRepository;

  static const String _usersCacheKey = 'users_cache';
  static const Duration _cacheExpiry = Duration(minutes: 5);

  @override
  Future<List<User>> getUsers() async {
    await _analyticsRepository.trackEvent('users_fetch_requested', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Try cache first
    final cachedUsers = await _cacheRepository.get<List<User>>(_usersCacheKey);
    if (cachedUsers != null) {
      await _analyticsRepository.trackEvent('users_cache_hit', {
        'user_count': cachedUsers.length,
      });
      return cachedUsers;
    }

    // Fetch from repository
    final users = await _userRepository.getUsers();

    // Cache the result
    await _cacheRepository.set(_usersCacheKey, users, ttl: _cacheExpiry);

    await _analyticsRepository.trackEvent('users_fetched_from_source', {
      'user_count': users.length,
      'cached': true,
    });

    return users;
  }

  @override
  Future<User?> getUserById(String id) async {
    await _analyticsRepository.trackEvent('user_fetch_by_id', {
      'user_id': id,
    });

    final cacheKey = 'user_$id';

    // Try cache first
    final cachedUser = await _cacheRepository.get<User>(cacheKey);
    if (cachedUser != null) {
      await _analyticsRepository.trackEvent('user_cache_hit', {
        'user_id': id,
      });
      return cachedUser;
    }

    // Fetch from repository
    final user = await _userRepository.getUserById(id);

    if (user != null) {
      // Cache the user
      await _cacheRepository.set(cacheKey, user, ttl: _cacheExpiry);

      await _analyticsRepository.trackEvent('user_fetched_from_source', {
        'user_id': id,
        'user_name': user.name,
      });
    }

    return user;
  }

  @override
  Future<User> createUser(String name, String email) async {
    await _analyticsRepository.trackEvent('user_create_requested', {
      'name': name,
      'email': email,
    });

    final user = await _userRepository.createUser(name, email);

    // Invalidate users cache
    await _cacheRepository.remove(_usersCacheKey);

    // Cache the new user
    await _cacheRepository.set('user_${user.id}', user, ttl: _cacheExpiry);

    await _analyticsRepository.trackEvent('user_created', {
      'user_id': user.id,
      'user_name': user.name,
      'user_email': user.email,
    });

    return user;
  }

  @override
  Future<User> updateUser(User user) async {
    await _analyticsRepository.trackEvent('user_update_requested', {
      'user_id': user.id,
      'user_name': user.name,
    });

    final updatedUser = await _userRepository.updateUser(user);

    // Update cache
    await _cacheRepository.set('user_${user.id}', updatedUser,
        ttl: _cacheExpiry);

    // Invalidate users list cache
    await _cacheRepository.remove(_usersCacheKey);

    await _analyticsRepository.trackEvent('user_updated', {
      'user_id': updatedUser.id,
      'is_active': updatedUser.isActive,
    });

    return updatedUser;
  }

  @override
  Future<void> deleteUser(String id) async {
    await _analyticsRepository.trackEvent('user_delete_requested', {
      'user_id': id,
    });

    await _userRepository.deleteUser(id);

    // Remove from cache
    await _cacheRepository.remove('user_$id');
    await _cacheRepository.remove(_usersCacheKey);

    await _analyticsRepository.trackEvent('user_deleted', {
      'user_id': id,
    });
  }

  @override
  Stream<List<User>> watchUsers() {
    // Track analytics for stream subscription
    _analyticsRepository.trackEvent('users_stream_subscribed', {
      'timestamp': DateTime.now().toIso8601String(),
    });

    return _userRepository.watchUsers();
  }

  /// Clear all user-related cache
  Future<void> clearCache() async {
    final keys = await _cacheRepository.getKeys();
    final userKeys = keys.where((key) => key.startsWith('user'));

    for (final key in userKeys) {
      await _cacheRepository.remove(key);
    }

    await _analyticsRepository.trackEvent('user_cache_cleared', {
      'cleared_keys_count': userKeys.length,
    });
  }
}
