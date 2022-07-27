import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sprinty/bloc/cubit/appcubit_cubit.dart';
import 'package:sprinty/shared/local/components.dart';

// ignore: must_be_immutable
class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  List<String> reminderList = [
    "1 day before",
    "1 hour before",
    "30 min before",
    "10 min before",
  ];
  List<String> repeatList = [
    "Daily",
    "Weekly",
  ];
  @override
  Widget build(BuildContext context) {
    // add task screen
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Form(
          key: formKey,
          child: Scaffold(
            backgroundColor: Colors.white,
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
                'Add task',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
            ),
            body: Padding(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DefaultFormField(
                      title: 'Title',
                      hint: 'Type some title',
                      isReadOnly: false,
                      controller: cubit.titleController,
                      errorMsg: 'Title is required',
                    ),
                    DefaultFormField(
                      errorMsg: 'Date is required',
                      title: cubit.dateController.text == ''
                          ? 'Date'
                          : cubit.dateController.text,
                      hint: '2021-01-30',
                      isReadOnly: true,
                      controller: cubit.dateController,
                      suffixButton: IconButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-12-01'),
                          ).then((value) {
                            cubit.dateController.text =
                                DateFormat.yMMMd().format(value!);
                          });
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: DefaultFormField(
                              errorMsg: 'StartTime is required',
                              title: 'Start time',
                              hint: cubit.startTimeController.text == ''
                                  ? '10:00 AM'
                                  : cubit.startTimeController.text,
                              isReadOnly: true,
                              controller: cubit.startTimeController,
                              suffixButton: IconButton(
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      helpText: '10:00 AM',
                                    ).then((value) {
                                      cubit.startTimeController.text =
                                          value!.format(context);
                                    });
                                  },
                                  icon: const Icon(Icons.access_time_rounded))),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: DefaultFormField(
                              errorMsg: 'endTime is required',
                              title: 'End time',
                              hint: cubit.endTimeController.text == ''
                                  ? '10:00 AM'
                                  : cubit.endTimeController.text,
                              isReadOnly: true,
                              controller: cubit.endTimeController,
                              suffixButton: IconButton(
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      helpText: '10:00 AM',
                                    ).then((value) {
                                      cubit.endTimeController.text =
                                          value!.format(context);
                                    });
                                  },
                                  icon: const Icon(Icons.access_time_rounded))),
                        ),
                      ],
                    ),
                    DefaultFormField(
                      errorMsg: 'Reminder is required',
                      title: 'Reminder',
                      hint: cubit.repeatController.text = '1 day before',
                      isReadOnly: true,
                      controller: cubit.reminderController,
                      suffixButton: DropdownButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32.sp,
                        items: reminderList.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          },
                        ).toList(),
                        onChanged: (String? value) {
                          cubit.reminderController.text = value!;
                        },
                      ),
                    ),
                    DefaultFormField(
                      // add it to the bloc and remove set state
                      errorMsg: 'repeat is required',

                      title: 'Repeat',
                      hint: cubit.repeatController.text = 'Daily',

                      controller: cubit.repeatController,
                      isReadOnly: true,
                      suffixButton: DropdownButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32.sp,
                        items: repeatList.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          },
                        ).toList(),
                        onChanged: (String? value) {
                          cubit.repeatController.text = value!;
                        },
                      ),
                    ),
                    // create color picker button
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff37C16E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // create logic for data base and create properly the database
                  // validate the form
                  if (formKey.currentState!.validate()) {
                    cubit.createTask(
                      formKey,
                      dateController: cubit.dateController,
                      endTimeController: cubit.endTimeController,
                      startTimeController: cubit.startTimeController,
                      titleController: cubit.titleController,
                      reminderController: cubit.reminderController,
                      repeatController: cubit.repeatController,
                    );
                    cubit.dateController.clear();
                    cubit.endTimeController.clear();
                    cubit.startTimeController.clear();
                    cubit.titleController.clear();
                    cubit.reminderController.clear();
                    cubit.repeatController.clear();
                    cubit.checkAndRebuild();
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  child: const Text(
                    'Create task',
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
