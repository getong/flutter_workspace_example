import 'package:flutter/material.dart';

class ResponsiveDrawer extends StatelessWidget {
  final bool isPermanent;

  const ResponsiveDrawer({super.key, required this.isPermanent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPermanent ? 280 : null,
      child: Drawer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 250;

            return Container(
              color: Colors.teal.shade50,
              child: Column(
                children: [
                  // Drawer Header
                  Container(
                    height: isPermanent ? 120 : 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade400, Colors.teal.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: isPermanent ? 25 : 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isPermanent ? Icons.computer : Icons.phone_android,
                            size: isPermanent ? 30 : 40,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isPermanent ? 'Desktop Mode' : 'Mobile Drawer',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isPermanent) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Width: ${constraints.maxWidth.toInt()}px',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Drawer Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        _buildDrawerItem(
                          Icons.home,
                          'Home',
                          'Main dashboard view',
                          isWide,
                          () => Navigator.pop(context),
                        ),
                        _buildDrawerItem(
                          Icons.analytics,
                          'Analytics',
                          'View app statistics',
                          isWide,
                          () => Navigator.pop(context),
                        ),
                        _buildDrawerItem(
                          Icons.people,
                          'Users',
                          'Manage user accounts',
                          isWide,
                          () => Navigator.pop(context),
                        ),
                        _buildDrawerItem(
                          Icons.inventory,
                          'Products',
                          'Product management',
                          isWide,
                          () => Navigator.pop(context),
                        ),
                        const Divider(height: 20),
                        _buildDrawerItem(
                          Icons.help,
                          'Help & Support',
                          'Get help and support',
                          isWide,
                          () => Navigator.pop(context),
                        ),
                        _buildDrawerItem(
                          Icons.info,
                          'About',
                          'App information',
                          isWide,
                          () => _showAboutDialog(context, isPermanent),
                        ),
                      ],
                    ),
                  ),
                  // Footer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      border: Border(
                        top: BorderSide(color: Colors.teal.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPermanent
                              ? Icons.desktop_windows
                              : Icons.mobile_friendly,
                          color: Colors.teal.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isPermanent
                                ? 'Permanent Sidebar'
                                : 'Overlay Drawer',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    String subtitle,
    bool showSubtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal.shade600),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: showSubtitle
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            )
          : null,
      onTap: onTap,
      dense: !showSubtitle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showAboutDialog(BuildContext context, bool isPermanent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About LayoutBuilder Demo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Mode: ${isPermanent ? 'Desktop' : 'Mobile/Tablet'}'),
            const SizedBox(height: 8),
            const Text(
              'This app demonstrates responsive design using LayoutBuilder widget.',
            ),
            const SizedBox(height: 8),
            const Text('Features:'),
            const Text('• Responsive drawer behavior'),
            const Text('• Different layouts per screen size'),
            const Text('• Real-time constraint information'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
