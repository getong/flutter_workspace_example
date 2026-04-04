import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

const currentUser = ProfileStats(
  name: 'Alex Thompson',
  email: 'alex.thompson@design.io',
  contacts: '124',
  messages: '8.2k',
);

const people = <Person>[
  Person(
    name: 'Alex Rivera',
    initials: 'AR',
    role: 'Product Design Lead',
    accent: AtriumColors.primaryBright,
    fill: Color(0xFFF8E6C4),
    isOnline: true,
  ),
  Person(
    name: 'Sarah Jenkins',
    initials: 'SJ',
    role: 'Brand Strategist',
    accent: Color(0xFF1C8AF4),
    fill: Color(0xFFE8F4FF),
    isOnline: true,
  ),
  Person(
    name: 'Michael Chen',
    initials: 'MC',
    role: 'Analytics Director',
    accent: Color(0xFFFFB703),
    fill: Color(0xFFFFF2CC),
    isOnline: true,
  ),
  Person(
    name: 'Elena Vance',
    initials: 'EV',
    role: 'Client Success',
    accent: Color(0xFF27C27A),
    fill: Color(0xFFE4FFF1),
    isOnline: true,
  ),
  Person(
    name: 'Jordan Miles',
    initials: 'JM',
    role: 'Motion Designer',
    accent: AtriumColors.tertiaryDeep,
    fill: Color(0xFFF4E8FF),
  ),
  Person(
    name: 'Design Team',
    initials: 'DT',
    role: '6 members',
    accent: AtriumColors.secondary,
    fill: Color(0xFFBCD2FF),
    icon: Icons.groups_rounded,
  ),
];

final chats = <ChatPreview>[
  ChatPreview(
    person: people[0],
    timestamp: '12:45 PM',
    unreadCount: 2,
    lastMessage: 'Did you see the final design proposal yet?',
    messages: const [
      MessageEntry(
        text:
            'Hey! Did you see the new design system update? The atrium theme is looking really clean.',
        time: '10:42 AM',
        isMe: false,
      ),
      MessageEntry(
        text:
            'I just checked it out. The tonal layering really makes the depth pop. The asymmetric grids are a nice touch too!',
        time: '10:45 AM',
        isMe: true,
      ),
      MessageEntry(
        text:
            'Exactly! I\'m starting the implementation now. Should we stick to the 24px spacing for the chat bubbles as per the editorial grouping rule?',
        time: '10:46 AM',
        isMe: false,
      ),
      MessageEntry(
        text:
            'Definitely. Let\'s keep it breathable. I\'ll send over the updated assets in a bit.',
        time: '10:48 AM',
        isMe: true,
        attachment: MessageAttachment(
          title: 'Atrium Assets',
          subtitle: 'Revised gradients and layout samples',
          colors: [Color(0xFFF4F3EE), Color(0xFFCE2D2F), Color(0xFF171717)],
        ),
      ),
      MessageEntry(
        text: 'Those look incredible. The light blue tints are perfect.',
        time: '10:50 AM',
        isMe: false,
      ),
    ],
  ),
  ChatPreview(
    person: people[1],
    timestamp: '10:30 AM',
    lastMessage: 'The project looks amazing. Let\'s touch base later.',
    messages: const [
      MessageEntry(
        text:
            'I reviewed the revised pitch deck. The pacing feels much better.',
        time: '9:12 AM',
        isMe: false,
      ),
      MessageEntry(
        text: 'Great. I will bring the final version to the stakeholder sync.',
        time: '9:18 AM',
        isMe: true,
      ),
    ],
  ),
  ChatPreview(
    person: people[5],
    timestamp: 'Yesterday',
    senderPrefix: 'You',
    lastMessage: 'Attached the moodboard for review.',
    messages: const [
      MessageEntry(
        text: 'Morning team. Sharing the latest moodboard for the campaign.',
        time: '8:15 AM',
        isMe: true,
      ),
      MessageEntry(
        text:
            'This direction feels stronger. The spacing is finally breathing.',
        time: '8:34 AM',
        isMe: false,
      ),
    ],
  ),
  ChatPreview(
    person: people[2],
    timestamp: 'Tuesday',
    lastMessage: 'I\'ll send over the analytics report by EOD.',
    messages: const [
      MessageEntry(
        text: 'Can you include the retention trendline as well?',
        time: '3:10 PM',
        isMe: true,
      ),
      MessageEntry(
        text: 'Yes. I\'ll send over the analytics report by EOD.',
        time: '3:14 PM',
        isMe: false,
      ),
    ],
  ),
  ChatPreview(
    person: people[3],
    timestamp: 'Monday',
    lastMessage: 'That sounds like a great plan!',
    messages: const [
      MessageEntry(
        text: 'We can stagger the onboarding sequence over three days.',
        time: '1:05 PM',
        isMe: true,
      ),
      MessageEntry(
        text: 'That sounds like a great plan!',
        time: '1:08 PM',
        isMe: false,
      ),
    ],
  ),
];

const profileActions = <SettingAction>[
  SettingAction(
    label: 'Account',
    icon: Icons.person_rounded,
    accent: Color(0xFF3478F6),
    background: Color(0xFFEAF3FF),
  ),
  SettingAction(
    label: 'Privacy',
    icon: Icons.lock_rounded,
    accent: Color(0xFFA649F5),
    background: Color(0xFFF3E8FF),
  ),
  SettingAction(
    label: 'Notifications',
    icon: Icons.notifications_rounded,
    accent: Color(0xFFFF7B22),
    background: Color(0xFFFFEFE2),
  ),
  SettingAction(
    label: 'Help',
    icon: Icons.help_rounded,
    accent: Color(0xFF179C8B),
    background: Color(0xFFE0FFFA),
  ),
];
