import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tracker_platform_interface.dart';

/// An implementation of [TrackerPlatform] that uses method channels.
class MethodChannelTracker extends TrackerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tracker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
