import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/di/providers.dart';
import 'core/observers/app_error_handler.dart';
import 'core/services/local_storage_adapter.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  /// Providers [the necessary dependencies for the app]
  final container = await bootstrap();
  container.read(appErrorHandlerProvider);
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

Future<ProviderContainer> bootstrap() async {
  final storage = await loadStorage();
  return ProviderContainer(
    overrides: [storageProvider.overrideWithValue(storage)],
    observers: [RiverpodErrorObserver(AppLogger())],
  );
}
