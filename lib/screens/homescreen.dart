import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/controllers/task_cubit.dart';
import 'package:to_do/screens/eventscreen.dart';
import 'package:to_do/task/models/task.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To Do',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'Pacifico',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12,
                        ),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteInputScreen(
                                taskIndex: index,
                              ),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => context
                                      .read<TaskCubit>()
                                      .toggleTask(task),
                                  child: Icon(
                                    task.isCompleted
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: task.isCompleted
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    task.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => context
                                      .read<TaskCubit>()
                                      .deleteTask(task.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Input field to add new task
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taskController,
                          decoration: InputDecoration(
                            hintText: 'Enter a new task...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        onPressed: () {
                          if (taskController.text.isNotEmpty) {
                            context.read<TaskCubit>().addTask(
                                  Task(
                                    id: DateTime.now().toString(),
                                    name: taskController.text,
                                    isCompleted: false,
                                    start: DateTime.now(),
                                    notes: '',
                                  ),
                                );
                            taskController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}