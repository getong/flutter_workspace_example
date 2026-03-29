import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/app_database.dart';

class TodoFormPage extends StatefulWidget {
  const TodoFormPage({required this.database, this.todoId, super.key});

  final AppDatabase database;
  final int? todoId;

  bool get isEditing => todoId != null;

  @override
  State<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.isEditing) {
      _loadTodoForEdit();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTodoForEdit() async {
    setState(() {
      _loading = true;
    });

    final Todo? todo = await widget.database.getTodoById(widget.todoId!);
    if (!mounted) {
      return;
    }

    if (todo == null) {
      context.go('/todos/${widget.todoId}');
      return;
    }

    _titleController.text = todo.title;
    _descriptionController.text = todo.description ?? '';

    setState(() {
      _loading = false;
    });
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final String title = _titleController.text;
    final String description = _descriptionController.text;

    if (widget.isEditing) {
      await widget.database.updateTodo(
        id: widget.todoId!,
        title: title,
        description: description,
      );
      if (mounted) {
        context.go('/todos/${widget.todoId}');
      }
    } else {
      final int id = await widget.database.createTodo(
        title: title,
        description: description,
      );
      if (mounted) {
        context.go('/todos/$id');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Todo' : 'Create Todo'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    maxLength: 120,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Example: Read Drift docs',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    minLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      hintText: 'Add details for this task.',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _saving ? null : _submit,
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_saving ? 'Saving...' : 'Save Todo'),
                  ),
                ],
              ),
            ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: _saving
              ? null
              : () {
                  if (widget.isEditing) {
                    context.go('/todos/${widget.todoId}');
                  } else {
                    context.go('/');
                  }
                },
          icon: const Icon(Icons.arrow_back),
          label: const Text('Cancel'),
        ),
      ],
    );
  }
}
