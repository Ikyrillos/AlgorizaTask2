// create task item in a list tile
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sprinty/bloc/cubit/appcubit_cubit.dart';
import 'package:sprinty/data/task.dart';

class TaskItem extends StatelessWidget {
  TaskItem({Key? key, required this.taskData}) : super(key: key);
  final Task taskData;
  final List<String> repeatList = [
    "All",
    "Delayed",
    "Completed",
    "Favorite",
    "Delete",
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [
                0.1,
                0.9,
              ],
              colors: [
                taskData.status != "New" && taskData.status != "Favorite"
                    ? Colors.redAccent
                    : Colors.greenAccent,
                taskData.status != "New" && taskData.status != "Favorite"
                    ? Colors.red
                    : Colors.green,
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: ScreenUtil().setWidth(10),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                height: 60.h,
                width: 200.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskData.title!,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      "${taskData.date!} ${taskData.startTime!}",
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  // PopupMenuItem 1
                  PopupMenuItem(
                    value: 1,
                    // row with 2 children
                    child: TextButton(
                      onPressed: () async {
                        await cubit
                            .updateToDatabase("New", taskData.id!)
                            .then((value) => cubit.scheduleTasksList())
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text('New'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    // row with 2 children
                    child: TextButton(
                      onPressed: () async {
                        await cubit
                            .updateToDatabase("Delayed", taskData.id!)
                            .then((value) => cubit.scheduleTasksList())
                            .then((value) => Navigator.canPop(context));
                      },
                      child: const Text('Delayed'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: TextButton(
                      onPressed: () async {
                        await cubit
                            .updateToDatabase('Favorite', taskData.id!)
                            .then((value) => cubit.scheduleTasksList())
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text('Favorite'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: TextButton(
                      onPressed: () {
                        cubit.updateToDatabase('Done', taskData.id!);
                        cubit.scheduleTasksList();
                        Navigator.pop(context);
                      },
                      child: const Text('Complete'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: TextButton(
                      onPressed: () async {
                        await cubit
                            .deleteFromDatabase(taskData.id!)
                            .then((value) => cubit.scheduleTasksList())
                            .then((value) => Navigator.pop(context))
                            .onError((error, stackTrace) =>
                                debugPrint(error.toString()));
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: ScreenUtil().setWidth(10),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ScheduleTaskItem extends StatelessWidget {
  const ScheduleTaskItem({
    Key? key,
    required this.taskData,
  }) : super(key: key);
  final Task taskData;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.3,
                  0.9,
                ],
                colors: [
                  Colors.greenAccent,
                  Colors.green,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                width: ScreenUtil().setWidth(10),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                height: 80.h,
                width: 210.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // clock icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.h),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 15.w,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(5),
                        ),
                        Text(
                          "${taskData.startTime!} - ${taskData.endTime!}",
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),
                    Text(
                      taskData.title!,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const Spacer(),
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  // PopupMenuItem 1
                  PopupMenuItem(
                    value: 1,
                    // row with 2 children
                    child: TextButton(
                      onPressed: () {
                        cubit.updateToDatabase('Done', taskData.id!);
                        cubit.scheduleTasksList();
                        Navigator.pop(context);
                      },
                      child: const Text('Complete task'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    // row with 2 children
                    child: TextButton(
                      onPressed: () {
                        cubit.updateToDatabase('Favorite', taskData.id!);
                        cubit.scheduleTasksList();
                        Navigator.pop(context);
                      },
                      child: const Text('Add to favorite'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    // row with 2 children
                    child: TextButton(
                      onPressed: () {
                        cubit.deleteFromDatabase(taskData.id!);
                        cubit.scheduleTasksList();
                        Navigator.pop(context);
                      },
                      child: const Text('Remove task'),
                    ),
                  ),
                ],
              ),
            ]));
      },
    );
  }
}
