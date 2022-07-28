// ignore_for_file: file_names

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sprinty/bloc/cubit/appcubit_cubit.dart';
import 'package:sprinty/shared/local/task_item.dart';

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var dateName = DateTime.now();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70.h,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 14,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Schedule',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 10.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 10.h,
                ),
                child: DatePicker(
                  DateTime.now(),
                  height: 80.h,
                  width: 60.w,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.green,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    var dateString = DateFormat.yMMMd().format(date);
                    dateName = date;
                    cubit.datePickerData = date;
                    cubit.datePickerController.text = dateString;
                    cubit.scheduleTasksList();
                  },
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Text(
                      DateFormat('EEEE').format(dateName),
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.yMMMMd().format(dateName),
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: cubit.scheduleTasks.isEmpty
                    ? const Center(
                        child: Text('if empty Select a date'),
                      )
                    : ListView.separated(
                        // ignore: prefer_const_constructors
                        itemBuilder: (context, index) {
                          return ScheduleTaskItem(
                            taskData: cubit.scheduleTasks[index],
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: AppCubit.get(context).scheduleTasks.length,
                      ),
              ))
            ],
          ),
        );
      },
    );
  }
}
