import 'package:flutter/widgets.dart';

import 'di/injection_container.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
}
