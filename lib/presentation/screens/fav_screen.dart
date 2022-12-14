import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprinty/bloc/cubit/appcubit_cubit.dart';
import 'package:sprinty/shared/local/task_item.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return cubit.favoriteTasks.isEmpty
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
                      taskData: cubit.favoriteTasks[index],
                     
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: AppCubit.get(context).favoriteTasks.length,
                  ),
                ));
      },
    );
  }
}
