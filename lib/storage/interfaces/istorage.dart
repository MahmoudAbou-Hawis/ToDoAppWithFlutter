abstract class IStorage<Element> {
  List<Element> getAllElements();

  Future<void> setElement({required Element element});

  Element? getElement({required dynamic key});

  Future<void> deleteElement({required dynamic key});

  Future<void> updateElement({required Element element});
}
