import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'DatePickerDialogRoute')
class DatePickerDialogPage extends StatefulWidget {
  const DatePickerDialogPage({super.key});

  @override
  State<DatePickerDialogPage> createState() => _DatePickerDialogPageState();
}

class _DatePickerDialogPageState extends State<DatePickerDialogPage> {
  final DateTime _today = DateUtils.dateOnly(DateTime.now());
  late final DateTime _firstDate = DateTime(_today.year - 1, 1, 1);
  late final DateTime _lastDate = DateTime(_today.year + 2, 12, 31);

  late DateTime _selectedDate = _today.add(const Duration(days: 2));
  late DateTime _inputModeDate = _today.add(const Duration(days: 14));
  DatePickerEntryMode _entryMode = DatePickerEntryMode.calendar;
  String _latestResult = 'No DatePickerDialog result yet.';

  Future<void> _openCalendarDialog() async {
    final DateTime? result = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext dialogContext) {
        return DatePickerDialog(
          initialDate: _selectedDate,
          firstDate: _firstDate,
          lastDate: _lastDate,
          helpText: 'Choose release date',
          confirmText: 'Save',
          cancelText: 'Dismiss',
          initialEntryMode: DatePickerEntryMode.calendar,
          onDatePickerModeChange: (DatePickerEntryMode mode) {
            setState(() {
              _entryMode = mode;
            });
          },
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _selectedDate = DateUtils.dateOnly(result);
      _latestResult =
          'Calendar dialog result: ${_formatDate(context, _selectedDate)}';
    });
  }

  Future<void> _openInputDialog() async {
    final DateTime? result = await showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return DatePickerDialog(
          initialDate: _inputModeDate,
          firstDate: _firstDate,
          lastDate: _lastDate,
          helpText: 'Enter a launch date',
          initialEntryMode: DatePickerEntryMode.input,
          fieldHintText: 'mm/dd/yyyy',
          fieldLabelText: 'Launch date',
          selectableDayPredicate: (DateTime value) {
            return value.weekday != DateTime.sunday;
          },
          onDatePickerModeChange: (DatePickerEntryMode mode) {
            setState(() {
              _entryMode = mode;
            });
          },
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _inputModeDate = DateUtils.dateOnly(result);
      _latestResult =
          'Input dialog result: ${_formatDate(context, _inputModeDate)}';
    });
  }

  String _formatDate(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DatePickerDialog Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'DatePickerDialog is the dialog widget behind Material date picking flows when you want to present the picker directly with showDialog().',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Calendar Entry Mode',
              description:
                  'Use DatePickerDialog directly when you want the date picker dialog widget instead of the showDatePicker convenience helper.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _openCalendarDialog,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Open calendar dialog'),
                  ),
                  const SizedBox(height: 12),
                  Text('Selected date: ${_formatDate(context, _selectedDate)}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Input Entry Mode',
              description:
                  'DatePickerDialog also supports text input mode, custom field labels, and day filtering.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OutlinedButton.icon(
                    onPressed: _openInputDialog,
                    icon: const Icon(Icons.keyboard_alt_outlined),
                    label: const Text('Open input dialog'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Input-mode date: ${_formatDate(context, _inputModeDate)}',
                  ),
                  const SizedBox(height: 8),
                  const Text('Sundays are disabled in this example.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Latest Result',
              description:
                  'DatePickerDialog returns a DateTime from Navigator.pop, and the last entry mode is tracked from dialog interaction.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_latestResult),
                  const SizedBox(height: 8),
                  Text('Last entry mode: $_entryMode'),
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
