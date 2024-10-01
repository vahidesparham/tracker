import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tracker_method_channel.dart';

abstract class TrackerPlatform extends PlatformInterface {
  /// Constructs a TrackerPlatform.
  TrackerPlatform() : super(token: _token);

  static final Object _token = Object();

  static TrackerPlatform _instance = MethodChannelTracker();

  /// The default instance of [TrackerPlatform] to use.
  ///
  /// Defaults to [MethodChannelTracker].
  static TrackerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TrackerPlatform] when
  /// they register themselves.
  static set instance(TrackerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
