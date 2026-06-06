import 'package:get_it/get_it.dart';

import '../../features/api_demo/presentation/bloc/api_demo_bloc.dart';

Future<void> setupBlocs(GetIt sl) async {
  sl.registerFactory(
    () =>
        ApiDemoBloc(fetchProfile: sl(), fetchProducts: sl(), tokenStore: sl()),
  );
}
