import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/controllers/task_cubit.dart';
import 'package:to_do/services/googleCalender/googlecalender.dart';
import 'package:to_do/task/adapters/connectionAdapter.dart';
import 'package:to_do/task/models/task.dart';

class NoteInputScreen extends StatefulWidget {
  final int taskIndex;

  const NoteInputScreen({Key? key, required this.taskIndex}) : super(key: key);

  @override
  _NoteInputScreenState createState() => _NoteInputScreenState();
}

class _NoteInputScreenState extends State<NoteInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  late final GoogleCalender calender;
  late final ConnectionAdapter adapter;
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  @override
  void initState() {
    super.initState();
    _initializeWithTaskData();
    calender = GoogleCalender();
    adapter = ConnectionAdapter(calender);
    calender.connect();
  }

  void _initializeWithTaskData() {
    final taskCubit = context.read<TaskCubit>();
    final task = taskCubit.state.tasks[widget.taskIndex];

    _noteController.text = task.notes ?? '';
    _startDateTime = task.start;
    _endDateTime = task.end;

    if (_startDateTime != null) {
      _startController.text = _formatDateTime(_startDateTime!);
    }
    if (_endDateTime != null) {
      _endController.text = _formatDateTime(_endDateTime!);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickStartDateTime() async {
    final initialDate = _startDateTime ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        setState(() {
          _startDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _startController.text = _formatDateTime(_startDateTime!);
        });
      }
    }
  }

  Future<void> _pickEndDateTime() async {
    final initialDate =
        _endDateTime ??
        (_startDateTime ?? DateTime.now()).add(const Duration(hours: 1));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        setState(() {
          _endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _endController.text = _formatDateTime(_endDateTime!);
        });
      }
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      if (_startDateTime == null || _endDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both start and end times'),
          ),
        );
        return;
      }

      if (_endDateTime!.isBefore(_startDateTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
        
      }

      final taskCubit = context.read<TaskCubit>();
      final currentTask = taskCubit.state.tasks[widget.taskIndex];
      print('TaskId');
      print(
        await adapter.addTask(
          currentTask.copyWith(
            name: currentTask.name, // Preserve existing name
            notes: _noteController.text.trim(),
            start: _startDateTime!,
            end: _endDateTime!,
            isCompleted: currentTask.isCompleted,
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = context.read<TaskCubit>().state.tasks[widget.taskIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentTask.name),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveNote),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Task Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        hintText: 'Enter task details...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: 5,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? 'Please enter some notes'
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickStartDateTime,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _startController,
                          decoration: InputDecoration(
                            labelText: 'Start Time',
                            hintText: 'Select start date and time',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator:
                              (value) =>
                                  _startDateTime == null
                                      ? 'Please select start time'
                                      : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickEndDateTime,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _endController,
                          decoration: InputDecoration(
                            labelText: 'End Time',
                            hintText: 'Select end date and time',
                            suffixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator:
                              (value) =>
                                  _endDateTime == null
                                      ? 'Please select end time'
                                      : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveNote,
                      child: const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
