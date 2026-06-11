import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storageBox = GetStorage();

  static const String keyFirstTime = "isFirstTime";
  static const String keyLoggedIn = "loggedIn";

  // Save a value
  void saveData(String key, dynamic value) {
    _storageBox.write(key, value);
  }

  // Read a value
  dynamic readData(String key) {
    return _storageBox.read(key);  
  }

  void clearStorage() {
    _storageBox.erase();
  
  }

  // Remove a value
  void removeData(String key) {
    _storageBox.remove(key);
  }

  // Check if a key exists
  bool hasData(String key) {
    return _storageBox.hasData(key);
  }

  // Check if user is opening app for the first time
  bool isFirstTime() => _storageBox.read(keyFirstTime) ?? true;

  // Mark first-time as complete
  void setFirstTime() => _storageBox.write(keyFirstTime, false);

  // Check if user is logged in
  bool isLoggedIn() => _storageBox.read(keyLoggedIn) ?? false;

  // Set user login status
  void setLoggedIn(bool value) => _storageBox.write(keyLoggedIn, value);

}
