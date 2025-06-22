import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

/// Settings page demonstrating global navigation features
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.settings, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Settings Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Global navigation examples
            const Text(
              '全局导航示例:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('全局登出'),
              subtitle: const Text('使用 _rootNavigatorKey 跳转到认证页面'),
              onTap: () {
                _showLogoutDialog(navigationService);
              },
            ),

            ListTile(
              leading: const Icon(Icons.fullscreen, color: Colors.purple),
              title: const Text('全屏覆盖层'),
              subtitle: const Text('展示脱离 Shell 的模态页面'),
              onTap: () => navigationService.showFullscreenOverlay(),
            ),

            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('全局信息对话框'),
              subtitle: const Text('从任何地方显示对话框'),
              onTap: () => _showGlobalInfoDialog(navigationService),
            ),

            ListTile(
              leading: const Icon(
                Icons.notification_important,
                color: Colors.orange,
              ),
              title: const Text('全局通知'),
              subtitle: const Text('显示全局 SnackBar'),
              onTap: () => navigationService.showGlobalSnackBar('设置页面的全局通知示例！'),
            ),

            const SizedBox(height: 30),

            // Navigation state info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '导航状态信息:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('可以返回: ${navigationService.canPop() ? "是" : "否"}'),
                  const SizedBox(height: 4),
                  const Text(
                    '当前页面在 Shell 内部，拥有持久的底部导航栏。'
                    '通过 _rootNavigatorKey 可以访问全局导航状态。',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(NavigationService navigationService) {
    navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('确认登出'),
        content: const Text('您确定要登出吗？这将跳转到认证页面。'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(navigationService.currentContext!).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(navigationService.currentContext!).pop();
              navigationService.showGlobalSnackBar('已登出');
              navigationService.navigateToLogin();
            },
            child: const Text('确认登出'),
          ),
        ],
      ),
    );
  }

  void _showGlobalInfoDialog(NavigationService navigationService) {
    navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('_rootNavigatorKey 优势'),
        content: const Text(
          '在设置页面中，我们可以:\n\n'
          '• 不依赖当前 BuildContext 进行导航\n'
          '• 显示全局对话框和通知\n'
          '• 检查全局导航状态\n'
          '• 处理认证流程\n'
          '• 管理深度链接\n\n'
          '这些功能都通过 NavigationService 和 _rootNavigatorKey 实现。',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(navigationService.currentContext!).pop(),
            child: const Text('明白了'),
          ),
        ],
      ),
    );
  }
}
