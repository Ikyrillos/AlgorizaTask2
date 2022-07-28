import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprinty/bloc/cubit/appcubit_cubit.dart';
import 'package:sprinty/shared/local/task_item.dart';
import 'package:sprinty/utils/notify_service.dart';

class AllScreen extends StatelessWidget {
  AllScreen({Key? key}) : super(key: key);
  final notify = NotificationService();
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return cubit.allTasks.isEmpty
            ? const Center(
                child: Text(
                  "Empty for Now",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  child: ListView.separated(
                    // ignore: prefer_const_constructors
                    itemBuilder: (context, index) {
                      var task = cubit.allTasks[index];
                      DateTime date =
                          DateFormat.jm().parse(task.startTime.toString());
                      var myTime = DateFormat("HH:mm").format(date);
                      var hours = int.parse(myTime.toString().split(':')[0]);
                      var minutes = int.parse(myTime.toString().split(':')[1]);
                      DateTime fullTime = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          hours,
                          minutes);
                      notify.createReminderAndRepeat(fullTime, task);
                      debugPrint(task.reminder);
                      return TaskItem(
                        taskData: cubit.allTasks[index],
                       
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: AppCubit.get(context).allTasks.length,
                  ),
                ));
      },
    );
  }
}
