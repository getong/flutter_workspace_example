import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.tableCalendar)
class TableCalendarPage extends StatefulWidget {
  const TableCalendarPage({super.key});

  @override
  State<TableCalendarPage> createState() => _TableCalendarPageState();
}

class _TableCalendarPageState extends State<TableCalendarPage> {
  static final DateTime _today = DateTime.now();
  static final DateTime _firstDay = DateTime(_today.year, _today.month - 3, 1);
  static final DateTime _lastDay = DateTime(_today.year, _today.month + 3, 31);

  final LinkedHashMap<DateTime, List<_AgendaItem>> _events =
      LinkedHashMap<DateTime, List<_AgendaItem>>(
        equals: isSameDay,
        hashCode: _calendarHashCode,
      )..addAll(_seedEvents(_today));

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = _today;
  DateTime? _selectedDay = _today;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<_AgendaItem> _eventsForDay(DateTime day) {
    final DateTime normalized = DateTime.utc(day.year, day.month, day.day);
    return _events[normalized] ?? const <_AgendaItem>[];
  }

  List<_AgendaItem> _eventsForRange(DateTime start, DateTime end) {
    final int dayCount = end.difference(start).inDays + 1;
    final List<_AgendaItem> agenda = <_AgendaItem>[];

    for (int index = 0; index < dayCount; index += 1) {
      final DateTime day = DateTime.utc(
        start.year,
        start.month,
        start.day + index,
      );
      agenda.addAll(_eventsForDay(day));
    }

    return agenda;
  }

  List<_AgendaItem> get _visibleAgenda {
    if (_rangeSelectionMode == RangeSelectionMode.toggledOn &&
        _rangeStart != null) {
      if (_rangeEnd != null) {
        return _eventsForRange(_rangeStart!, _rangeEnd!);
      }
      return _eventsForDay(_rangeStart!);
    }

    if (_selectedDay != null) {
      return _eventsForDay(_selectedDay!);
    }

    return const <_AgendaItem>[];
  }

  void _resetCalendar() {
    setState(() {
      _calendarFormat = CalendarFormat.month;
      _focusedDay = _today;
      _selectedDay = _today;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final List<_AgendaItem> visibleAgenda = _visibleAgenda;

    return Scaffold(
      appBar: AppBar(title: const Text('table_calendar Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'table_calendar is a customizable calendar widget. This page '
              'shows month/week switching, selected-day handling, range '
              'selection, custom markers, and a Flutter agenda view driven by '
              'the selected calendar state.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Interactive Calendar',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.tonalIcon(
                          onPressed: _resetCalendar,
                          icon: const Icon(Icons.today_outlined),
                          label: const Text('Jump To Today'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _rangeStart = null;
                              _rangeEnd = null;
                              _selectedDay = _focusedDay;
                              _rangeSelectionMode =
                                  RangeSelectionMode.toggledOff;
                            });
                          },
                          icon: const Icon(Icons.layers_clear_outlined),
                          label: const Text('Clear Range'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: TableCalendar<_AgendaItem>(
                        firstDay: _firstDay,
                        lastDay: _lastDay,
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (DateTime day) {
                          return isSameDay(_selectedDay, day);
                        },
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        rangeSelectionMode: _rangeSelectionMode,
                        eventLoader: _eventsForDay,
                        availableCalendarFormats:
                            const <CalendarFormat, String>{
                              CalendarFormat.month: 'Month',
                              CalendarFormat.twoWeeks: '2 Weeks',
                              CalendarFormat.week: 'Week',
                            },
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        pageJumpingEnabled: true,
                        headerStyle: const HeaderStyle(
                          titleCentered: true,
                          formatButtonShowsNext: false,
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          markerDecoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          rangeHighlightColor: colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          rangeStartDecoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          rangeEndDecoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders<_AgendaItem>(
                          markerBuilder:
                              (
                                BuildContext context,
                                DateTime day,
                                List<_AgendaItem> events,
                              ) {
                                if (events.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${events.length}',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                );
                              },
                        ),
                        onDaySelected:
                            (DateTime selectedDay, DateTime focusedDay) {
                              if (isSameDay(_selectedDay, selectedDay)) {
                                return;
                              }

                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _rangeStart = null;
                                _rangeEnd = null;
                                _rangeSelectionMode =
                                    RangeSelectionMode.toggledOff;
                              });
                            },
                        onRangeSelected:
                            (
                              DateTime? start,
                              DateTime? end,
                              DateTime focusedDay,
                            ) {
                              setState(() {
                                _selectedDay = null;
                                _focusedDay = focusedDay;
                                _rangeStart = start;
                                _rangeEnd = end;
                                _rangeSelectionMode =
                                    RangeSelectionMode.toggledOn;
                              });
                            },
                        onFormatChanged: (CalendarFormat format) {
                          if (_calendarFormat == format) {
                            return;
                          }

                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onPageChanged: (DateTime focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        Chip(
                          label: Text(
                            'Focused: ${DateFormat.yMMMd().format(_focusedDay)}',
                          ),
                        ),
                        Chip(label: Text('Format: ${_calendarFormat.name}')),
                        Chip(
                          label: Text(
                            'Range mode: ${_rangeSelectionMode.name}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Agenda For Current Selection',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (visibleAgenda.isEmpty)
                      const Text(
                        'No agenda items for the current selection. Long press a day to start range selection.',
                      )
                    else
                      Column(
                        children: visibleAgenda
                            .map((_AgendaItem item) => _AgendaTile(item: item))
                            .toList(growable: false),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _AgendaTile extends StatelessWidget {
  const _AgendaTile({required this.item});

  final _AgendaItem item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.event_note_outlined),
        title: Text(item.title),
        subtitle: Text(
          '${DateFormat.MMMd().format(item.day)}  ${item.timeLabel}\n'
          '${item.description}',
        ),
        isThreeLine: true,
        titleTextStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AgendaItem {
  const _AgendaItem({
    required this.day,
    required this.title,
    required this.description,
    required this.timeLabel,
  });

  final DateTime day;
  final String title;
  final String description;
  final String timeLabel;
}

int _calendarHashCode(DateTime day) {
  return day.day * 1000000 + day.month * 10000 + day.year;
}

Map<DateTime, List<_AgendaItem>> _seedEvents(DateTime today) {
  final DateTime anchor = DateTime.utc(today.year, today.month, today.day);
  return <DateTime, List<_AgendaItem>>{
    anchor: <_AgendaItem>[
      _AgendaItem(
        day: anchor,
        title: 'Calendar review',
        description:
            'Check month and week transitions while preserving selection state.',
        timeLabel: '09:30',
      ),
      _AgendaItem(
        day: anchor,
        title: 'Marker polish',
        description:
            'Verify custom event markers still read clearly on mobile.',
        timeLabel: '14:00',
      ),
    ],
    DateTime.utc(today.year, today.month, today.day + 2): <_AgendaItem>[
      _AgendaItem(
        day: DateTime.utc(today.year, today.month, today.day + 2),
        title: 'Range selection pass',
        description:
            'Long-press to enable a range and compare the resulting agenda.',
        timeLabel: '11:15',
      ),
    ],
    DateTime.utc(today.year, today.month, today.day + 5): <_AgendaItem>[
      _AgendaItem(
        day: DateTime.utc(today.year, today.month, today.day + 5),
        title: 'Sprint planning',
        description: 'Use agenda cards to summarize a dense day.',
        timeLabel: '10:00',
      ),
      _AgendaItem(
        day: DateTime.utc(today.year, today.month, today.day + 5),
        title: 'Design sync',
        description:
            'Confirm the calendar layout still feels intentional on tablet width.',
        timeLabel: '16:30',
      ),
    ],
  };
}
