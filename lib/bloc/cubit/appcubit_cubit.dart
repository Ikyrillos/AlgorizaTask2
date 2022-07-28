import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprinty/data/task.dart';
import 'package:sqflite/sqflite.dart';

part 'appcubit_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppcubitInitial());

  static AppCubit get(context) => BlocProvider.of(context);
  String? taskItemTitle, hint;
  String? remindValue = "1", repeatValue;
  int currentIndex = 0;
  List<Task> newTasks = [];
  List<Task> allTasks = [];
  List<Task> completedTasks = [];
  List<Task> delayedTasks = [];
  List<Task> favoriteTasks = [];
  List<Task> scheduleTasks = [];
  var datePickerData = DateTime.now();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var datePickerController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  var reminderController = TextEditingController();
  var repeatController = TextEditingController();
  var colorController = TextEditingController();

  Database? database;

  void createDataBase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE task(id INTEGER PRIMARY KEY, title TEXT, date TEXT, startTime TEXT,endTime TEXT,reminder TEXT ,repeat TEXT ,status TEXT,color TEXT,isCompleted INTEGER)')
          .then((value) {});
    }, onOpen: (database) {
      selectFromDatabase(database);
    }).then((value) {
      database = value;
    });
    emit(DataBaseCreationState());
  }

  Future<void> insertIntoDatabase({
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    required String remind,
    required String repeat,
    String? priority,
    String? description,
  }) async {
    await database!.transaction((txn) {
      newTasks = [];
      allTasks = [];
      completedTasks = [];
      delayedTasks = [];
      favoriteTasks = [];
      scheduleTasks = [];

      return txn
          .rawInsert(
              'INSERT INTO task(title,date,startTime,endTime,reminder, repeat ,status) VALUES ("$title","$date","$startTime", "$endTime", "$remind", "$repeat","New")')
          .then((value) {
        emit(InsertIntoDataBaseState());
        debugPrint(value as String);
        selectFromDatabase(database);
      }).catchError((e) {});
    });
  }

  Future<void> updateToDatabase(String status, int id) async {
    await database!.execute(
        'UPDATE task SET status =? WHERE id=?', [status, id]).then((value) {
      emit(UpdateTaskDataBaseState());
      allTasks = [];
      newTasks = [];
      completedTasks = [];
      delayedTasks = [];
      favoriteTasks = [];
      selectFromDatabase(database);
    });
  }

  Future<void> deleteFromDatabase(int id) async {
    try {
      await database!.execute('DELETE FROM task WHERE id =?', [id]);
      newTasks = [];
      completedTasks = [];
      delayedTasks = [];
      allTasks = [];
      emit(DeleteFromDataBaseState());

      selectFromDatabase(database);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // add to favorite
  void addToFavorite(int id) {
    database!.execute('UPDATE task SET status =? WHERE id=?', ['Favorite', id]);
    newTasks = [];
    completedTasks = [];
    delayedTasks = [];
    favoriteTasks = [];
    selectFromDatabase(database);
  }

  void selectFromDatabase(database) {
    database!.rawQuery("SELECT * FROM task").then((value) {
      scheduleTasksList();

      value.forEach((element) {
        addTaskToList(listName: allTasks, element: element);
        if (element["status"] == "New") {
          addTaskToList(listName: newTasks, element: element);
        } else if (element["status"] == "Done") {
          addTaskToList(listName: completedTasks, element: element);
        } else if (element["status"] == "Delayed") {
          addTaskToList(listName: delayedTasks, element: element);
        } else if (element["status"] == "Favorite") {
          addTaskToList(listName: favoriteTasks, element: element);
        }
      });
      emit(SelectFromDataBaseState());
    });
  }

  void checkAndRebuild() {
    database!.rawQuery("SELECT * FROM task").then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.forEach((element) {
        addTaskToList(listName: allTasks, element: element);
        if (element["status"] == "New") {
          addTaskToList(listName: newTasks, element: element);
        } else if (element["status"] == "Done") {
          addTaskToList(listName: completedTasks, element: element);
        } else if (element["status"] == "Delayed") {
          addTaskToList(listName: delayedTasks, element: element);
        } else if (element["status"] == "Favorite") {
          addTaskToList(listName: favoriteTasks, element: element);
        }
      });

      emit(SelectFromDataBaseState());
      emit(ScheduleTasksState());
    });
  }

  final formKey = GlobalKey<FormState>();
  var isValid = false;

  void createTask(
    formKey, {
    required TextEditingController dateController,
    required TextEditingController titleController,
    required TextEditingController startTimeController,
    required TextEditingController endTimeController,
    required TextEditingController? reminderController,
    required TextEditingController? repeatController,
  }) {
    try {
      if (dateController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          startTimeController.text.isNotEmpty) {
        insertIntoDatabase(
          title: titleController.text,
          date: dateController.text,
          startTime: startTimeController.text,
          endTime: endTimeController.text,
          repeat: repeatController!.text,
          remind: reminderController!.text,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addTaskToList({required List<Task> listName, required element}) {
    listName.add(Task(
        title: element["title"] as String,
        id: element["id"] as int,
        date: element["date"] as String,
        startTime: element["startTime"] as String,
        endTime: element["endTime"] as String,
        repeat: element["repeat"] as String,
        reminder: element["reminder"] as String,
        status: element["status"] as String));
  }

  void scheduleTasksList() {
    scheduleTasks = [];
    for (var element in allTasks) {
      if (element.date == datePickerController.text) {
        scheduleTasks.add(element);
      } else if (element.date != datePickerController.text) {
        scheduleTasks.remove(element);
      }
    }
    emit(ScheduleTasksState());
  }
}
