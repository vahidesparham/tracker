import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/tracker.dart';
import 'package:tracker/tracker_platform_interface.dart';
import 'package:tracker/tracker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTrackerPlatform
    with MockPlatformInterfaceMixin
    implements TrackerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TrackerPlatform initialPlatform = TrackerPlatform.instance;

  test('$MethodChannelTracker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTracker>());
  });

  test('getPlatformVersion', () async {
    Tracker trackerPlugin = Tracker();
    MockTrackerPlatform fakePlatform = MockTrackerPlatform();
    TrackerPlatform.instance = fakePlatform;

    expect(await trackerPlugin.getPlatformVersion(), '42');
  });
}
