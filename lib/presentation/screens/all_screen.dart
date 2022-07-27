import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprinty/bloc/cubit/appcubit_cubit.dart';
import 'package:sprinty/shared/local/task_item.dart';

class AllScreen extends StatelessWidget {
  const AllScreen({Key? key}) : super(key: key);

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
                    itemBuilder: (context, index) => TaskItem(
                      taskData: cubit.allTasks[index],
                      onPressed: () {
                        cubit.deleteFromDatabase(cubit.allTasks[index].id!);
                      },
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: AppCubit.get(context).allTasks.length,
                  ),
                ));
      },
    );
  }
}
