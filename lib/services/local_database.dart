
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  // Box name
  final String boxName = 'parent_app_by_ats';

  // Flag to check if Hive is initialized
  bool _isInitialized = false;

  // Initialize Hive
  Future<void> initializeHive() async {
    if (!_isInitialized) {
      // Get the application document directory
      final directory = await getApplicationDocumentsDirectory();

      // Initialize Hive
      Hive.init(directory.path);
      _isInitialized = true;
    }
  }

  // Open or get the box
  Future<Box> _openBox() async {
    await initializeHive(); // Ensure Hive is initialized
    return await Hive.openBox(boxName);
  }

  // Save image bytes to Hive using a custom ID
  Future<void> saveImage(Map<String, dynamic> data) async {
    var box = await _openBox();
    await box.put(data['dataTableName'],
        <Map<String, dynamic>>[data]); // Use the custom imageId as the key
  }

  // Retrieve image bytes from Hive using a custom ID
  Future<dynamic> getImage(Map<String, dynamic> query) async {
    var box = await _openBox();
    List<dynamic>? savedDataList = await box.get(query['dataTableName']);
    if (savedDataList != null) {
      return savedDataList.cast<dynamic>().firstWhere(
        (element) {
          return element['id'] == query['id'] &&
              element['dataTableName'] == query['dataTableName'];
        },
      );
    } else {
      return null;
    }
    // Retrieve the image by its custom ID
  }

  // Retrieve all saved image IDs
  // Future<List<String>> getAllSavedImageIds() async {
  //   var box = await _openBox();
  //   return box.keys
  //       .map((key) => key.toString())
  //       .toList(); // Return all saved image IDs
  // }
}
