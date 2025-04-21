import 'package:flutter/material.dart';
import 'package:to_do/task/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_do/task/coreInitializer/coreinitializer.dart';
import 'package:to_do/storage/interfaces/istorage.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInit(null)) {
    fetchTasks();
  }

  addTask(Task task) async {
    await state.hiveStorage?.setElement(element: task);
    emit(TasksActive([...state.tasks, task], state.hiveStorage));
  }

  fetchTasks() async {
    print("hello");
    var init = Coreinitializer();
    await init.initDatabases();
    var hivedb = await init.getTaskStorage();  
    emit(TasksActive(hivedb.getAllElements(), hivedb));
  }

  deleteTask(String id) async {
    await state.hiveStorage?.deleteElement(key: id);
    final List<Task> list = state.tasks.where((task) => task.id != id).toList();
    emit(TasksActive(list, state.hiveStorage));
  }

  Future<void> toggleTask(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

    await state.hiveStorage?.updateElement(element: updatedTask);

    final list =
        state.tasks.map((t) {
          if (t.name == task.name) {
            return updatedTask;
          }
          return t;
        }).toList();

    emit(TasksActive(list, state.hiveStorage));
  }
}
