import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/local_storage_service.dart';
import 'pages/home_page.dart';
import 'pages/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Initialize your storage service
  final storageService = LocalStorageService();
  try {
    await storageService.ensureInitialized();
  } catch (e) {
    //print('Error initializing storage: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taboo Game',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}
