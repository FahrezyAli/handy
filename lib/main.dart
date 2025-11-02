import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'views/home_view.dart';
import 'bloc/timer_bloc.dart';
import 'models/timer_settings.dart';
import 'models/work_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TimerSettingsAdapter());
  Hive.registerAdapter(WorkSessionAdapter());
  await Hive.openBox<TimerSettings>('settings');
  await Hive.openBox<WorkSession>('sessions');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(),
      child: MaterialApp(
        title: 'Work Timer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF2D2D44),
          fontFamily: 'Montserrat-Alternates',
        ),
        home: const HomeView(),
      ),
    );
  }
}
