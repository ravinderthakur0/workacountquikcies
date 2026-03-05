
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/screens/main_shell.dart';
import 'package:myapp/services/audio_service.dart';
import 'package:myapp/services/permission_service.dart';
import 'dart:developer' as developer;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final Directory appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
  } catch (e, s) {
    developer.log(
      'Error initializing Hive',
      name: 'my_app.main',
      error: e,
      stackTrace: s,
    );
  }
  await AudioServiceHandler.init();
  await PermissionService.requestPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainShell(),
    );
  }
}
