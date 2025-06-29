import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/gallery_page.dart';
import 'pages/settings_page.dart';
import 'widgets/responsive_drawer.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'LayoutBuilder Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ResponsiveDemo(),
    ),
  );
}

class ResponsiveDemo extends StatelessWidget {
  const ResponsiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                isDesktop
                    ? 'LayoutBuilder Desktop Demo'
                    : 'LayoutBuilder Mobile Demo',
              ),
              backgroundColor: Colors.teal,
              leading: isDesktop
                  ? null
                  : Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: const Icon(Icons.dashboard),
                    text: isDesktop ? 'Dashboard' : 'Dash',
                  ),
                  Tab(
                    icon: const Icon(Icons.photo_library),
                    text: isDesktop ? 'Gallery' : 'Photos',
                  ),
                  Tab(
                    icon: const Icon(Icons.settings),
                    text: isDesktop ? 'Settings' : 'Config',
                  ),
                ],
              ),
            ),
            drawer: isDesktop ? null : ResponsiveDrawer(isPermanent: false),
            body: Row(
              children: [
                // Permanent sidebar for desktop
                if (isDesktop) ResponsiveDrawer(isPermanent: true),
                // Main content
                Expanded(
                  child: const TabBarView(
                    children: [DashboardPage(), GalleryPage(), SettingsPage()],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
