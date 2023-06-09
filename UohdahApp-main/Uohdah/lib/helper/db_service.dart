import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final _database = openDatabase(
    'location.db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE location (
          id INTEGER PRIMARY KEY,
          latitude REAL,
          longitude REAL,
          timestamp INTEGER
        )
      ''');
    },
  );

  Future<void> saveLocation(Position position) async {
    final db = await _database;
    await db.insert('location', {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    final db = await _database;
    return db.query('location');
  }
}




