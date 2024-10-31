import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box;

  StorageService._internal(this._box);

  static final StorageService _instance = StorageService._internal(GetStorage());

  factory StorageService() => _instance;

  Future<void> init() async {
    await GetStorage.init();
  }

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> clear() async {
    await _box.erase();
  }
}
