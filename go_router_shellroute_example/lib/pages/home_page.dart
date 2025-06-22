import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';

/// Home page demonstrating comprehensive _rootNavigatorKey usage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => navigationService.navigateToLogin(),
            icon: const Icon(Icons.login),
            tooltip: 'Global Auth Navigation',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'GoRouter _rootNavigatorKey Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Basic navigation examples
            _buildSectionTitle('Basic Navigation Examples'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/home/details/123'),
              child: const Text('Go to Details (ID: 123)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.push('/home/details/456'),
              child: const Text('Push Details (ID: 456)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () =>
                  context.goNamed('details', pathParameters: {'id': '789'}),
              child: const Text('Named Route Details (ID: 789)'),
            ),

            const SizedBox(height: 30),

            // Global navigation examples using NavigationService
            _buildSectionTitle('Global Navigation (_rootNavigatorKey)'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => navigationService.navigateToRoute('/auth'),
              icon: const Icon(Icons.login),
              label: const Text('Global Auth Navigation'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => navigationService.showFullscreenOverlay(),
              icon: const Icon(Icons.fullscreen),
              label: const Text('Fullscreen Overlay'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showGlobalDialog(navigationService),
              icon: const Icon(Icons.info),
              label: const Text('Global Dialog'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => navigationService.showGlobalSnackBar(
                'Global SnackBar from HomePage!',
              ),
              icon: const Icon(Icons.message),
              label: const Text('Global SnackBar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),

            const SizedBox(height: 30),

            // Deep link simulation
            _buildSectionTitle('Deep Link Simulation'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () =>
                  navigationService.handleDeepLink('profile/user123'),
              icon: const Icon(Icons.link),
              label: const Text('Simulate Profile Deep Link'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () =>
                  navigationService.handleDeepLink('settings/theme'),
              icon: const Icon(Icons.link),
              label: const Text('Simulate Settings Deep Link'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            ),

            const SizedBox(height: 30),

            // Information section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '_rootNavigatorKey 的强大功能:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem('🌐 全局导航控制 - 无需 BuildContext'),
                  _buildFeatureItem('🔐 认证流程管理 - 全屏登录页面'),
                  _buildFeatureItem('📱 模态覆盖层 - 脱离 Shell 显示'),
                  _buildFeatureItem('🔗 深度链接处理 - 外部链接重定向'),
                  _buildFeatureItem('⚠️ 全局错误处理 - 统一错误页面'),
                  _buildFeatureItem('🎯 类型安全路由 - 编译时检查'),
                  _buildFeatureItem('💬 全局对话框和提示 - 任意位置显示'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Try switching between tabs using the bottom navigation bar. '
              'Notice how the navigation bar persists across all pages, '
              'but full-screen routes bypass the shell entirely.',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  void _showGlobalDialog(NavigationService navigationService) {
    navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('全局对话框示例'),
        content: const Text(
          '这个对话框通过 _rootNavigatorKey 显示，'
          '可以在应用的任何地方调用，无需当前页面的 BuildContext。\n\n'
          '这展示了 NavigationService 如何利用 _rootNavigatorKey '
          '实现真正的全局导航控制。',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(navigationService.currentContext!).pop(),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(navigationService.currentContext!).pop();
              navigationService.navigateToRoute('/settings');
            },
            child: const Text('跳转到设置'),
          ),
        ],
      ),
    );
  }
}
