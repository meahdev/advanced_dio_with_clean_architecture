import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app_theme.dart';
import 'app/bootstrap.dart';
import 'app/di/injection_container.dart';
import 'features/api_demo/presentation/bloc/api_demo_bloc.dart';
import 'features/api_demo/presentation/screens/api_demo_screen.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dio Advanced',
      theme: AppTheme.light(),
      home: BlocProvider(
        create: (_) => sl<ApiDemoBloc>(),
        child: const ApiDemoScreen(),
      ),
    );
  }
}
