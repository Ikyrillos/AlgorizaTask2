import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprinty/presentation/screens/all_screen.dart';
import 'package:sprinty/presentation/screens/calender_Screen.dart';
import 'package:sprinty/presentation/screens/completed_screen.dart';
import 'package:sprinty/presentation/screens/fav_screen.dart';
import 'package:sprinty/presentation/screens/uncompleted_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sprinty/utils/notify_helper.dart';
import '../../bloc/cubit/appcubit_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var notificationHelper;
  @override
  void initState() {
    super.initState();
    notificationHelper = NotificationHelper();
    notificationHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Board',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.black,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_today_rounded,
                      color: Colors.black),
                  onPressed: () {
                    cubit.scheduleTasksList();
                    var notify = NotificationHelper();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CalenderScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                tabs: const [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Completed',
                  ),
                  Tab(
                    text: 'Delayed',
                  ),
                  Tab(
                    text: 'Favorite',
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                unselectedLabelStyle: TextStyle(
                  fontSize: 13.sp,
                ),
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: const TabBarView(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                AllScreen(),
                CompletedScreen(),
                UnCompletedScreen(),
                FavoriteScreen(),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff37C16E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'addTask');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    'Add a task',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
