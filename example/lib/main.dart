import 'package:flutter/material.dart';
import 'package:tracker/tracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService().init(distanceFilter: 10, interval: 10, minDistance: 50.0);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Background Location Tracker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await LocationService().startLocationService();
                },
                child: Text('Start Location Service'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await LocationService().stopLocationService();
                },
                child: Text('Stop Location Service'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, dynamic>> unsyncedLocations = await LocationService().getUnsyncedLocations();
                  print('Unsynced Locations: $unsyncedLocations');
                },
                child: Text('Get Unsynced Locations'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Example: Set locations with IDs 1, 2, and 3 as synced
                  await LocationService().setLocationsSynced([1, 2, 3]);
                },
                child: Text('Set Locations Synced'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Example: Get the oldest 5 locations
                  List<Map<String, dynamic>> oldestLocations = await LocationService().getOldestNLocations(5);
                  print('Oldest Locations: $oldestLocations');
                },
                child: Text('Get Oldest N Locations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
