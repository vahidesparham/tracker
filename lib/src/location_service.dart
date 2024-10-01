import 'dart:math';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  Database? _database;
  double _distanceFilter = 0;
  int _interval = 5;
  double _minDistance = 0.0;
  LocationDto? _lastLocation;

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  Future<void> init({double distanceFilter = 0, int interval = 5, double minDistance = 0.0}) async {
    _distanceFilter = distanceFilter;
    _interval = interval;
    _minDistance = minDistance;
    await _requestPermissions();
    await BackgroundLocator.initialize();
    await _initDatabase();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      status = await Permission.locationAlways.request();
      if (!status.isGranted) {
        throw Exception('Location permission not granted');
      }
    }
  }

  Future<void> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'locations.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Locations (id INTEGER PRIMARY KEY, latitude REAL, longitude REAL, timestamp TEXT, isSync INTEGER)',
        );
        await db.execute(
          'CREATE TABLE GpsStatus (id INTEGER PRIMARY KEY, status TEXT, timestamp TEXT)',
        );
      },
    );
  }

  Future<void> startLocationService() async {
    await _logGpsStatus('on');
    BackgroundLocator.registerLocationUpdate(
      _callback,
      androidSettings: AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: _distanceFilter,
        interval: _interval,
        androidNotificationSettings: const AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg: 'Background location tracking is active',
          notificationIcon: '',
          notificationIconColor: Colors.grey,
        ),
      ),
      iosSettings: IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: _distanceFilter,
      ),
    );
  }

  Future<void> stopLocationService() async {
    await _logGpsStatus('off');
    await BackgroundLocator.unRegisterLocationUpdate();
  }

  static void _callback(LocationDto locationDto) async {
    final db = await _instance._database;
    if (_instance._lastLocation == null ||
        _calculateDistance(_instance._lastLocation!, locationDto) > _instance._minDistance) {
      await db?.insert('Locations', {
        'latitude': locationDto.latitude,
        'longitude': locationDto.longitude,
        'timestamp': DateTime.now().toIso8601String(),
        'isSync': 0, // 0 represents false
      });
      _instance._lastLocation = locationDto;
    }
  }

  static double _calculateDistance(LocationDto start, LocationDto end) {
    const double p = 0.017453292519943295; // Pi/180
    final double a = 0.5 -
        cos((end.latitude - start.latitude) * p) / 2 +
        cos(start.latitude * p) * cos(end.latitude * p) * (1 - cos((end.longitude - start.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<void> _logGpsStatus(String status) async {
    final db = await _database;
    await db?.insert('GpsStatus', {
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getUnsyncedLocations() async {
    final db = await _database;
    return await db?.query('Locations', where: 'isSync = ?', whereArgs: [0]) ?? [];
  }

  Future<void> setLocationsSynced(List<int> ids) async {
    final db = await _database;
    for (int id in ids) {
      await db?.update(
        'Locations',
        {'isSync': 1}, // 1 represents true
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<Map<String, dynamic>>> getOldestNLocations(int n) async {
    final db = await _database;
    return await db?.query(
          'Locations',
          orderBy: 'timestamp ASC',
          limit: n,
        ) ??
        [];
  }
}
