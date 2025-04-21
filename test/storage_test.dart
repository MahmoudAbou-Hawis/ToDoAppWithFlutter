import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:to_do/storage/dbFactory.dart';
import 'package:to_do/storage/interfaces/istorage.dart';

class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    return User(name: reader.readString(), age: reader.readInt());
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.age);
  }
}

String getId(User a) {
  return a.name;
}

void main() async {
  late IStorage<User> userStorage;

  setUp(() async {
    await setUpTestHive();
    userStorage = await Dbfactory.createDb<User>(
      name: 'name',
      marshaller: UserAdapter(),
      getId: getId,
    );
  });

  test('Storage adds and retrieves a user', () async {
    final user = User(name: 'Buy milk', age: 30);
    await userStorage.setElement(element: user);

    final retrieved = userStorage.getElement(key: 'Buy milk');
    expect(retrieved, isNotNull);
    expect(retrieved!.name, equals('Buy milk'));
    expect(retrieved.age, equals(30));
  });

  test('Storage updates a user', () async {
    final user = User(name: 'John', age: 25);
    await userStorage.setElement(element: user);

    final updatedUser = User(name: 'John', age: 40);
    await userStorage.updateElement(element: updatedUser);

    final retrieved = userStorage.getElement(key: 'John');
    expect(retrieved!.age, equals(40));
  });

  test('Storage deletes a user', () async {
    final user = User(name: 'Jane', age: 22);
    await userStorage.setElement(element: user);

    await userStorage.deleteElement(key: 'Jane');

    final deleted = userStorage.getElement(key: 'Jane');
    expect(deleted, isNull);
  });

  test('Storage throws error when updating non-existent user', () async {
    final user = User(name: 'Ghost', age: 99);

    await expectLater(
      () async => await userStorage.updateElement(element: user),
      throwsA(isA<RangeError>()),
    );
  });

  test('Storage retrive all elements', () async {
    final user = User(name: 'John', age: 46);
    await userStorage.setElement(element: user);
    List<User> list = userStorage.getAllElements();

    expect(list, [
      User(name: 'Buy milk', age: 30),
      User(name: 'John', age: 46),
    ]);
  });
}
