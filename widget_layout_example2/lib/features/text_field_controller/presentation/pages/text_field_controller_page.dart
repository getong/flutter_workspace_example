import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.textFieldController)
class TextFieldControllerPage extends StatefulWidget {
  const TextFieldControllerPage({super.key});

  @override
  State<TextFieldControllerPage> createState() =>
      _TextFieldControllerPageState();
}

class _TextFieldControllerPageState extends State<TextFieldControllerPage> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Flutter learner',
  );
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _sharedController = TextEditingController(
    text: 'Shared controller text',
  );
  final TextEditingController _firstSeparateController = TextEditingController(
    text: 'First separate value',
  );
  final TextEditingController _secondSeparateController = TextEditingController(
    text: 'Second separate value',
  );

  String _liveName = 'Flutter learner';
  String _submittedMessage = 'Nothing submitted yet.';
  String _sharedValue = 'Shared controller text';
  String _firstSeparateValue = 'First separate value';
  String _secondSeparateValue = 'Second separate value';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_handleNameChanged);
    _sharedController.addListener(_handleSharedChanged);
    _firstSeparateController.addListener(_handleSeparateChanged);
    _secondSeparateController.addListener(_handleSeparateChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleNameChanged);
    _sharedController.removeListener(_handleSharedChanged);
    _firstSeparateController.removeListener(_handleSeparateChanged);
    _secondSeparateController.removeListener(_handleSeparateChanged);
    _nameController.dispose();
    _messageController.dispose();
    _sharedController.dispose();
    _firstSeparateController.dispose();
    _secondSeparateController.dispose();
    super.dispose();
  }

  void _handleNameChanged() {
    setState(() {
      _liveName = _nameController.text;
    });
  }

  void _handleSharedChanged() {
    setState(() {
      _sharedValue = _sharedController.text;
    });
  }

  void _handleSeparateChanged() {
    setState(() {
      _firstSeparateValue = _firstSeparateController.text;
      _secondSeparateValue = _secondSeparateController.text;
    });
  }

  void _copyNameToMessage() {
    _messageController.text = 'Hello, $_liveName!';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message field updated from controller.')),
    );
  }

  void _submitMessage() {
    setState(() {
      _submittedMessage = _messageController.text.isEmpty
          ? 'Nothing submitted yet.'
          : _messageController.text;
    });
  }

  void _clearFields() {
    _nameController.clear();
    _messageController.clear();
    setState(() {
      _submittedMessage = 'Nothing submitted yet.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextField + TextEditingController Module'),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'TextEditingController gives programmatic access to a TextField value. It is useful for reading text, reacting to changes, updating text from code, and clearing fields.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Live Controller Value',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This field updates the preview below by listening to the controller.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Type your name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Live preview: ${_liveName.isEmpty ? '(empty)' : _liveName}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Control Text From Code',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Buttons below write to the second TextField, submit its value, or clear both fields.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _messageController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message',
                        hintText: 'Write a short message',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton(
                          onPressed: _copyNameToMessage,
                          child: const Text('Prefill Message'),
                        ),
                        OutlinedButton(
                          onPressed: _submitMessage,
                          child: const Text('Submit Message'),
                        ),
                        TextButton(
                          onPressed: _clearFields,
                          child: const Text('Clear Fields'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Submitted message: $_submittedMessage',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Two TextFields, One TextEditingController',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Both TextFields below use the same controller. Editing either field updates the other one immediately.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _sharedController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Shared Field A',
                        hintText: 'Type here',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sharedController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Shared Field B',
                        hintText: 'The same text appears here',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Shared value: ${_sharedValue.isEmpty ? '(empty)' : _sharedValue}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Two TextFields, Two TextEditingControllers',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These TextFields use different controllers, so each field keeps its own value.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _firstSeparateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Separate Field A',
                        hintText: 'First controller',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _secondSeparateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Separate Field B',
                        hintText: 'Second controller',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Field A value: ${_firstSeparateValue.isEmpty ? '(empty)' : _firstSeparateValue}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Field B value: ${_secondSeparateValue.isEmpty ? '(empty)' : _secondSeparateValue}',
                      style: Theme.of(context).textTheme.bodyLarge,
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
