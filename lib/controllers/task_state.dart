part of 'task_cubit.dart';

@immutable
sealed class TaskState extends Equatable {
  final List<Task> tasks;
  final IStorage? hiveStorage;

  TaskState(this.tasks,this.hiveStorage);

  @override
  List<Object?> get props => [tasks];
}

class TaskInit extends TaskState {
  TaskInit(hiveStorage) : super([],hiveStorage);
}

class TasksFetch extends TaskState {
  TasksFetch(super.tasks,super.hiveStorage);
}

class TasksActive extends TaskState {
  TasksActive(super.tasks,super.hiveStorage);
}
