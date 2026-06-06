import 'package:get_it/get_it.dart';

import 'blocs_injection.dart';
import 'core_injection.dart';
import 'datasources_injection.dart';
import 'repositories_injection.dart';
import 'usecases_injection.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await setupCore(sl);
  await setupDataSources(sl);
  await setupRepositories(sl);
  await setupUseCases(sl);
  await setupBlocs(sl);
}
