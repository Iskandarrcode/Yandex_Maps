import 'package:dars9/cubits/restorant_cubit.dart';
import 'package:dars9/services/location_service.dart';
import 'package:dars9/views/screens/yandex_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService.checkPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RestorantCubit(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: YandexMapScreen(),
      ),
    );
  }
}
