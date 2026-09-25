import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../l10n/app_localizations.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? taskToEdit;

  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _tagsController;
  late TaskCategory _category;
  late TaskPriority _priority;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descController = TextEditingController(text: task?.description ?? '');
    _tagsController = TextEditingController(text: task?.tags.join(', ') ?? '');
    _category = task?.category ?? TaskCategory.work;
    _priority = task?.priority ?? TaskPriority.medium;
    _dueDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = context.read<TaskProvider>();
      final tagsList = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      if (widget.taskToEdit != null) {
        final updatedTask = widget.taskToEdit!.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          category: _category,
          priority: _priority,
          dueDate: _dueDate,
          tags: tagsList,
        );
        await taskProvider.updateTask(updatedTask);
      } else {
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          category: _category,
          priority: _priority,
          dueDate: _dueDate,
          tags: tagsList,
          createdAt: DateTime.now(),
        );
        await taskProvider.addTask(newTask);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? l10n.editTask : l10n.addTask)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              Semantics(
                label: 'Task title input field',
                hint: 'Enter task title',
                textField: true,
                child: TextFormField(
                  key: const Key('task_title_input'),
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: '${l10n.title} *',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.requiredField;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Description Field
              Semantics(
                label: 'Task description input field',
                hint: 'Enter task details and description',
                textField: true,
                child: TextFormField(
                  key: const Key('task_desc_input'),
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              Semantics(
                label: 'Category selector dropdown',
                hint: 'Select task category',
                child: DropdownButtonFormField<TaskCategory>(
                  // ignore: deprecated_member_use
                  value: _category,
                  decoration: InputDecoration(
                    labelText: l10n.category,
                    border: const OutlineInputBorder(),
                  ),
                  items: TaskCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(l10n.categoryName(cat)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _category = val);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              Semantics(
                label: 'Priority selector dropdown',
                hint: 'Select task priority level',
                child: DropdownButtonFormField<TaskPriority>(
                  // ignore: deprecated_member_use
                  value: _priority,
                  decoration: InputDecoration(
                    labelText: l10n.priority,
                    border: const OutlineInputBorder(),
                  ),
                  items: TaskPriority.values.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(l10n.priorityName(p)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _priority = val);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              Semantics(
                label: 'Due date selector',
                hint: 'Tap to pick due date',
                button: true,
                child: InkWell(
                  onTap: () => _selectDueDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.dueDate,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat('dd MMMM yyyy').format(_dueDate)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tags Field
              Semantics(
                label: 'Tags input field',
                hint: 'Enter comma-separated tags',
                textField: true,
                child: TextFormField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: l10n.tags,
                    hintText: 'ex: Flutter, Dev, Urgent',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              Semantics(
                label: 'Save task button',
                hint: 'Tap to save task changes',
                button: true,
                child: ElevatedButton.icon(
                  key: const Key('save_task_button'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveForm,
                  icon: const Icon(Icons.save),
                  label: Text(
                    l10n.save,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
