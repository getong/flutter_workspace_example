import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DatePickerPage extends StatefulWidget {
  const DatePickerPage({super.key});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  final DateTime _today = DateUtils.dateOnly(DateTime.now());
  late final DateTime _firstDate = DateTime(_today.year - 1, 1, 1);
  late final DateTime _lastDate = DateTime(_today.year + 2, 12, 31);

  late DateTime _selectedDate = _today.add(const Duration(days: 3));
  late DateTime _calendarDate = _selectedDate;
  DateTime? _typedDate;
  DateTimeRange? _selectedRange;

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      helpText: 'Select release date',
      confirmText: 'Save',
      selectableDayPredicate: (DateTime date) {
        return date.weekday != DateTime.sunday;
      },
    );

    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = DateUtils.dateOnly(pickedDate);
      _calendarDate = _selectedDate;
    });
  }

  Future<void> _pickRange() async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialDateRange:
          _selectedRange ??
          DateTimeRange(
            start: _selectedDate,
            end: _selectedDate.add(const Duration(days: 5)),
          ),
      helpText: 'Select planning window',
      saveText: 'Apply range',
    );

    if (!mounted || range == null) {
      return;
    }

    setState(() {
      _selectedRange = range;
    });
  }

  String _formatDate(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  String _formatRange(BuildContext context, DateTimeRange range) {
    return '${_formatDate(context, range.start)} to ${_formatDate(context, range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DatePicker Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'Flutter offers dialog-based, inline, and text-input date pickers depending on the amount of space and guidance you want to provide.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'showDatePicker Dialog',
              description:
                  'Use the built-in dialog when a date should be chosen in a focused step of the flow.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Open Date Picker'),
                  ),
                  const SizedBox(height: 12),
                  Text('Selected date: ${_formatDate(context, _selectedDate)}'),
                  const SizedBox(height: 8),
                  const Text(
                    'Sundays are disabled by the selectable day predicate.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Inline CalendarDatePicker',
              description:
                  'Embed a calendar directly in the page when date selection is central to the layout.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CalendarDatePicker(
                    initialDate: _calendarDate,
                    firstDate: _firstDate,
                    lastDate: _lastDate,
                    onDateChanged: (DateTime value) {
                      setState(() {
                        _calendarDate = DateUtils.dateOnly(value);
                      });
                    },
                  ),
                  Text(
                    'Inline calendar value: ${_formatDate(context, _calendarDate)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'InputDatePickerFormField',
              description:
                  'This version accepts typed dates and validates against the same boundaries as the dialog picker.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputDatePickerFormField(
                    initialDate: _typedDate ?? _selectedDate,
                    firstDate: _firstDate,
                    lastDate: _lastDate,
                    fieldLabelText: 'Launch date',
                    fieldHintText: 'mm/dd/yyyy',
                    onDateSubmitted: (DateTime value) {
                      setState(() {
                        _typedDate = DateUtils.dateOnly(value);
                      });
                    },
                    onDateSaved: (DateTime value) {
                      setState(() {
                        _typedDate = DateUtils.dateOnly(value);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _typedDate == null
                        ? 'Typed date: not submitted yet'
                        : 'Typed date: ${_formatDate(context, _typedDate!)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Date Range Planning',
              description:
                  'Related date APIs like showDateRangePicker are useful for booking, scheduling, and reporting windows.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: _pickRange,
                    icon: const Icon(Icons.date_range),
                    label: const Text('Pick Date Range'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _selectedRange == null
                        ? 'No range selected yet.'
                        : 'Planning window: ${_formatRange(context, _selectedRange!)}',
                  ),
                ],
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

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
