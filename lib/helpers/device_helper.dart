import 'package:uuid/uuid.dart';

class DeviceHelper {
  static String generateUserId() {
    final uuid = Uuid();
    return uuid.v4();
  }
}
