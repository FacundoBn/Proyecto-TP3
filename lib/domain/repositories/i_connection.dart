abstract class IConnection {
  Future<List<Map<String, dynamic>>> fetchCollection(String collectionName);
  Future<void> saveCollection(String collectionName, List<Map<String, dynamic>> data);
}
