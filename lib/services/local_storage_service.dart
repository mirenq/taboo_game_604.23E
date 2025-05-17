import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RoundResults {
    final int? id;
    final String teamA;
    final String teamB;
    final int scoreA;
    final int scoreB;
    final int timeMinutes;
    final String winResult;

    const RoundResults({
        this.id, 
        required this.teamA, 
        required this.teamB, 
        required this.scoreA, 
        required this.scoreB, 
        required this.timeMinutes, 
        required this.winResult
    });

    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'teamA': teamA,
            'teamB': teamB,
            'scoreA': scoreA,
            'scoreB': scoreB,
            'timeMinutes': timeMinutes,
            'winResult': winResult,
        };
    }

    factory RoundResults.fromMap(Map<String, dynamic> map) {
        return RoundResults(
            id: map['id'],
            teamA: map['teamA'],
            teamB: map['teamB'],
            scoreA: map['scoreA'],
            scoreB: map['scoreB'],
            timeMinutes: map['timeMinutes'],
            winResult: map['winResult'],
        );
    }

    @override
    String toString() {
        return 'Match{id: $id, teamA: $teamA, teamB: $teamB, scoreA: $scoreA, scoreB: $scoreB, timeMinutes: $timeMinutes, winResult: $winResult}';
    }
}

class LocalStorageService {
    static final LocalStorageService _instance = LocalStorageService._internal();
    static Database? _database;

    factory LocalStorageService() => _instance;

    LocalStorageService._internal();

    // getting instance of database
    Future<Database> get database async {
        if (_database != null) return _database!;
        _database = await _initDatabase();
        return _database!;
    }

    // initializing database
    Future<Database> _initDatabase() async {
        String path = join(await getDatabasesPath(), 'results_database.db');
        return await openDatabase(path, version: 1, onCreate: _createDb,);
    }

    // creating database table
    Future<void> _createDb(Database db, int version) async {
        await db.execute(''' 
            CREATE TABLE roundResults(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                teamA TEXT NOT NULL,
                teamB TEXT NOT NULL,
                scoreA INTEGER NOT NULL,
                scoreB INTEGER NOT NULL,
                timeMinutes INTEGER NOT NULL,
                winResults TEXT NOT NULL
            )
        ''');
    }

    // inserting round results
    Future<int> insertRound(RoundResults round) async {
        final Database db = await database;
        return await db.insert(
            'rounds',
            round.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    // updating a round in db
    Future<int> updateRound(RoundResults round) async {
        final Database db = await database;
        return await db.update(
            'rounds',
            round.toMap(),
            where: 'id = ?',
            whereArgs: [round.id],
        );
    }

    // deleting a round in db
    Future<int> deleteRound(int id) async {
        final Database db = await database;
        return await db.delete(
            'rounds',
            where: 'id = ?',
            whereArgs: [id],
        );
    }

    // getting all rounds from db
    Future<List<RoundResults>> getRounds() async {
        final Database db = await database;
        final List<Map<String, dynamic>> maps = await db.query('rounds');
        return List.generate(maps.length, (i) {
            return RoundResults.fromMap(maps[i]);
        });
    }

    // get a specific round by id
    Future<RoundResults?> getRound(int id) async {
        final Database db = await database;
        final List<Map<String, dynamic>> maps = await db.query(
            'rounds',
            where: 'id = ?',
            whereArgs: [id],
        );

        if (maps.isNotEmpty) {
            return RoundResults.fromMap(maps.first);
        }
        return null;
    }

    // get rounds by team name 
    Future<List<RoundResults>> getRoundsByTeam(String teamName) async {
        final Database db = await database;
        final List<Map<String, dynamic>> maps = await db.query(
            'rounds',
            where: 'teamA = ? OR team = ?',
            whereArgs: [teamName, teamName],
        );

        return List.generate(maps.length, (i) {
            return RoundResults.fromMap(maps[i]);
        });
    }

    // close the db
    Future<void> close() async {
        final Database db = await database;
        await db.close();
    }
}