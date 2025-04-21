import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'interfaces/istorage.dart';

class Storage<Element> implements IStorage<Element> {
  final Box<Element> _box;
  final TypeAdapter<Element> _marsheller;
  final dynamic Function(Element) getId;

  static final Map<String, Storage<dynamic>> _singleton =
      <String, Storage<dynamic>>{};

  @override
  List<Element> getAllElements() {
    return _box.values.toList();
  }

  @override
  Future<void> setElement({required Element element}) async {
    await _box.put(getId(element), element);
  }

  @override
  Element? getElement({required dynamic key}) {
    return _box.get(key);
  }

  @override
  Future<void> deleteElement({required dynamic key}) async {
    await _box.delete(key);
  }

  @override
  Future<void> updateElement({required Element element}) async {
    final isElementFound = getElement(key: getId(element));
    if (isElementFound == null) {
      throw RangeError('Not Found Element With Key: ${getId(element)}');
    }
    await _box.put(getId(element), element);
  }

  Storage._internal(this._box, this._marsheller, this.getId)  {
//    Hive.registerAdapter(_marsheller);
  }
  factory Storage({
    required Box<Element> box,
    required TypeAdapter<Element> marshaller,
    required dynamic Function(Element) getId,
  }) {
    if (_singleton.containsKey(box.name)) {
      return _singleton[box.name] as Storage<Element>;
    } else {
      final instance = Storage._internal(box, marshaller, getId);
      _singleton[box.name] = instance;
      return instance;
    }
  }
}
