
import 'tracker_platform_interface.dart';

class Tracker {
  Future<String?> getPlatformVersion() {
    return TrackerPlatform.instance.getPlatformVersion();
  }
}
