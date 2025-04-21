import 'package:to_do/task/containers/storages.dart';
import 'package:to_do/task/coreInitializer/coreinitializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do/task/models/task.dart';
import 'package:hive_test/hive_test.dart';

void main() async {
  late TaskStorage taskStorage;
  Coreinitializer core = Coreinitializer();
  setUp(() async {
    await setUpTestHive();
    taskStorage = await core.getTaskStorage() ;
  });

  test('Storage adds and retrieves a task', () async {
    final task = Task(
      id: '1',
      name: 'Buy milk',
      email: 'test@mail.com',
      start: DateTime(2024, 1, 1),
      end:  DateTime(2024, 3, 1),
      isCompleted: false,
      notes: '2 liters',
    );

    await taskStorage.setElement(element: task);

    final retrieved = taskStorage.getElement(key: '1');
    expect(retrieved, isNotNull);
    expect(retrieved!.name, equals('Buy milk'));
    expect(retrieved.notes, equals('2 liters'));
  });

  test('Storage updates a task', () async {
    final task = Task(
      id: '2',
      name: 'Wash car',
      email: 'test@mail.com',
      start: DateTime(2024, 1, 1),
      end:  DateTime(2024, 3, 1),
      isCompleted: false,
      notes: 'use shampoo',
    );

    await taskStorage.setElement(element: task);

    final updatedTask = Task(
      id: '2',
      name: 'Wash car',
      email: 'test@mail.com',
      start: DateTime(2024, 1, 1),
      end:  DateTime(2024, 3, 1),
      isCompleted: true,
      notes: 'done',
    );

    await taskStorage.updateElement(element: updatedTask);

    final retrieved = taskStorage.getElement(key: '2');
    expect(retrieved!.isCompleted, isTrue);
    expect(retrieved.notes, equals('done'));
  });

  test('Storage deletes a task', () async {
    final task = Task(
      id: '3',
      name: 'Read book',
      email: 'test@mail.com',
      start: DateTime(2024, 1, 1),
      end:  DateTime(2024, 3, 1),
      isCompleted: false,
      notes: 'Flutter in Action',
    );

    await taskStorage.setElement(element: task);
    await taskStorage.deleteElement(key: '3');

    final deleted = taskStorage.getElement(key: '3');
    expect(deleted, isNull);
  });

  test('Storage throws error when updating non-existent task', () async {
    final task = Task(
      id: '404',
      name: 'Ghost task',
      email: 'ghost@mail.com',
      start: DateTime(2024, 1, 1),
      end:  DateTime(2024, 3, 1),
      isCompleted: false,
      notes: 'invisible',
    );

    await expectLater(
      () async => await taskStorage.updateElement(element: task),
      throwsA(isA<RangeError>()),
    );
  });

  test('Storage retrieves all tasks', () async {
    final task1 = Task(
      id: '5',
      name: 'Clean room',
      email: 'a@mail.com',
      start: DateTime(2024, 1, 1),
      end:  DateTime(2024, 3, 1),
      isCompleted: false,
      notes: '',
    );

    final task2 = Task(
      id: '6',
      name: 'Do homework',
      email: 'b@mail.com',
      start: DateTime(2024, 1, 1),
      end:  DateTime(2024, 3, 1),
      isCompleted: true,
      notes: 'math & science',
    );

    await taskStorage.setElement(element: task1);
    await taskStorage.setElement(element: task2);

    final list = taskStorage.getAllElements();
    expect(list, containsAll([task1, task2]));
  });
}
