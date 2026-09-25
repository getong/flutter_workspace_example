import 'package:flutter/material.dart';

import 'package:mai_ui_demo/app/state/travel_store.dart';

class EditNameDialog extends StatefulWidget {
  const EditNameDialog({super.key, required this.store});
  final TravelStore store;
  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late final controller = TextEditingController(text: widget.store.name);
  String? error;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void save() {
    if (controller.text.trim().isEmpty) {
      setState(() => error = '请输入昵称');
      return;
    }
    widget.store.rename(controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('编辑资料'),
    content: TextField(
      controller: controller,
      autofocus: true,
      maxLength: 20,
      decoration: InputDecoration(labelText: '昵称', errorText: error),
      onSubmitted: (_) => save(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('取消'),
      ),
      FilledButton(onPressed: save, child: const Text('保存')),
    ],
  );
}
