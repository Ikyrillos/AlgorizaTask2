part of 'appcubit_cubit.dart';

@immutable
abstract class AppStates {}

class AppcubitInitial extends AppStates {}

class BottomNavIndexState extends AppStates {}

class DataBaseCreationState extends AppStates {}

// ignore: must_be_immutable
class SelectFromDataBaseState extends AppStates {}

class DeleteFromDataBaseState extends AppStates {}

class InsertIntoDataBaseState extends AppStates {}

class UpdateTaskDataBaseState extends AppStates {}
class ScheduleTasksState extends AppStates {}

class AddScreenState extends AppStates {}

class RemindValueState extends AppStates {}

class RepeatValueState extends AppStates {}

//class CreateFormState extends AppStates {}

class SetIconState extends AppStates {}
