import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sprinty/bloc/cubit/appcubit_cubit.dart';
import 'package:sprinty/presentation/screens/add_task.dart';
import 'package:sprinty/presentation/screens/all_screen.dart';
import 'package:sprinty/presentation/screens/completed_screen.dart';
import 'package:sprinty/presentation/screens/fav_screen.dart';
import 'package:sprinty/presentation/screens/my_home_page.dart';
import 'package:sprinty/presentation/screens/uncompleted_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, screenUtil) {
        return BlocProvider(
          create: (context) => AppCubit()..createDataBase(),
          child: MaterialApp(
            routes: {
              'home': (context) => const MyHomePage(title: 'Sprinty'),
              'addTask': (context) => AddTaskScreen(),
              'all': (context) =>  AllScreen(),
              'completed': (context) => const CompletedScreen(),
              'delayed': (context) => const UnCompletedScreen(),
              'favorite': (context) => const FavoriteScreen(),
            },
            initialRoute: 'home',
            title: 'Sprinty',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
          ),
        );
      },
    );
  }
}
