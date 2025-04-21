import 'package:hive/hive.dart';
import 'interfaces/istorage.dart';
import 'storage.dart';

class Dbfactory {
  static Future<IStorage<Element>> createDb<Element>({
    required String name,
    required TypeAdapter<Element> marshaller,
    required dynamic Function(Element) getId,
  }) async {
    Box<Element>  box = await Hive.openBox<Element>(name);
    return Storage(box: box, marshaller: marshaller, getId: getId);
  }
}
