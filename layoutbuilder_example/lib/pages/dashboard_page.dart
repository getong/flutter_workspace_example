import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        String layoutType;
        Widget layoutWidget;
        Color backgroundColor;

        if (constraints.maxWidth > 800) {
          layoutType = 'DESKTOP DASHBOARD';
          backgroundColor = Colors.blue.shade100;
          layoutWidget = _buildDesktopDashboard(constraints);
        } else if (constraints.maxWidth > 500) {
          layoutType = 'TABLET DASHBOARD';
          backgroundColor = Colors.orange.shade100;
          layoutWidget = _buildTabletDashboard(constraints);
        } else {
          layoutType = 'MOBILE DASHBOARD';
          backgroundColor = Colors.green.shade100;
          layoutWidget = _buildMobileDashboard(constraints);
        }

        return Container(
          color: backgroundColor,
          child: Column(
            children: [
              // Constraint Information Panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.black87,
                child: Column(
                  children: [
                    Text(
                      '📊 $layoutType',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Width: ${constraints.maxWidth.toInt()}px | Height: ${constraints.maxHeight.toInt()}px',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: layoutWidget),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopDashboard(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                SizedBox(height: 20),
                Icon(Icons.dashboard, size: 60, color: Colors.white),
                Text(
                  'NAVIGATION',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text('Home', style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.analytics, color: Colors.white),
                  title: Text(
                    'Analytics',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.white),
                  title: Text('Users', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Main content
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: List.generate(6, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 40,
                        color: Colors.blue.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Chart ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${(index + 1) * 1234}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletDashboard(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.dashboard, color: Colors.white, size: 30),
                Text(
                  'TABLET DASHBOARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.tablet, color: Colors.white, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: List.generate(6, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange.shade300,
                        radius: 25,
                        child: Icon(Icons.trending_up, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Metric ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDashboard(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.phone_android, size: 40, color: Colors.white),
                Text(
                  'MOBILE DASHBOARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green.shade400,
                        child: Icon(Icons.insert_chart, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dashboard Item ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Value: ${(index + 1) * 567}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.green.shade400,
                        size: 16,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
