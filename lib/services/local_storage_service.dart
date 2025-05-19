import 'dart:async';

//import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/score_model.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  Box<Map>? _roundsBox;
  bool _initialized = false;

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  // getting instance of database
  Future<Box<Map>> get database async {
    if (_roundsBox != null) return _roundsBox!;
    await _initDatabase();
    return _roundsBox!;
  }

  // initializing database
  Future<void> _initDatabase() async {
    if (!_initialized) {
      await Hive.initFlutter();
      // Open box for storing rounds
      _roundsBox = await Hive.openBox<Map>('rounds');
      _initialized = true;
      //print('Hive database initialized successfully');
    }
  }

  Future<void> ensureInitialized() async {
    try {
      await database;
      //print('Database initialized successfully');
    } catch (e) {
      //print('Database initialization error: $e');
    }
  }

  // inserting round results
  Future<int> insertRound(RoundResults round) async {
    final box = await database;
    final id = box.length + 1; // Simple auto-increment

    // Convert round to map and add ID
    final Map<String, dynamic> roundMap = round.toMap();
    roundMap['id'] = id;

    // Store in Hive
    await box.put(id, roundMap);
    //print('Saved round with ID: $id');
    return id;
  }

  // deleting a round in db
  Future<void> deleteRound(int id) async {
    final box = await database;
    await box.delete(id);
  }

  // getting all rounds from db
  Future<List<RoundResults>> getRounds() async {
    final box = await database;
    final List<RoundResults> rounds = [];

    // Debugging
    //print('Retrieving rounds from Hive: ${box.length} entries found');

    try {
      for (var key in box.keys) {
        final data = box.get(key);
        //print('Retrieved data for key $key: $data');

        if (data != null) {
          final roundMap = Map<String, dynamic>.from(data);
          final round = RoundResults.fromMap(roundMap);
          rounds.add(round);
        }
      }
    } catch (e) {
      //print('Error retrieving rounds: $e');
    }

    //print('Returning ${rounds.length} rounds');
    return rounds;
  }

  // close the db
  Future<void> close() async {
    final box = await database;
    await box.close();
  }

  Future<void> clearRounds() async {
    final box = await database;
    await box.clear();
  }
}
