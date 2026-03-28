import 'package:flutter/material.dart';

import 'back_home_button.dart';

class ListViewHorizontalPage extends StatelessWidget {
  const ListViewHorizontalPage({super.key});

  static const List<_StoryCard> _stories = <_StoryCard>[
    _StoryCard(title: 'Sunrise', icon: Icons.wb_sunny_outlined),
    _StoryCard(title: 'Travel', icon: Icons.flight_takeoff_outlined),
    _StoryCard(title: 'Music', icon: Icons.music_note_outlined),
    _StoryCard(title: 'Coffee', icon: Icons.coffee_outlined),
    _StoryCard(title: 'Coding', icon: Icons.code_outlined),
    _StoryCard(title: 'Workout', icon: Icons.fitness_center_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Horizontal ListView')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Horizontal lists are good for stories, channels, or filters.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _stories.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) {
                  final _StoryCard card = _stories[index];
                  return Container(
                    width: 140,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.cyan, Colors.indigo],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(card.icon, color: Colors.white, size: 30),
                        const Spacer(),
                        Text(
                          card.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Swipe for more',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: const <Widget>[BackHomeButton()],
    );
  }
}

class _StoryCard {
  const _StoryCard({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
