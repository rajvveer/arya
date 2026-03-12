import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/journal_entry.dart';
import 'data/models/session_state_model.dart';
import 'data/repositories/journal_repository.dart';
import 'data/repositories/session_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(SessionStateModelAdapter());
  await JournalRepository.openBox();
  await SessionRepository.openBox();

  runApp(
    const ProviderScope(
      child: ArvyaXApp(),
    ),
  );
}
