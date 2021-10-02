import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

@DataClassName('TaskToDo')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id, name};
}

@UseMoor(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          FlutterQueryExecutor.inDatabaseFolder(
              path: 'db.sqlite', logStatements: true),
        );
  @override
  int get schemaVersion => 1;

  Future<List<TaskToDo>> getAllTasks() => select(tasks).get();
  Stream<List<TaskToDo>> watchAllTasks() => select(tasks).watch();
  Future<void> insertTaskToDo(TaskToDo task) => into(tasks).insert(task);
  Future<void> updateTaskToDo(TaskToDo task) => update(tasks).replace(task);
  Future<void> deleteTaskToDo(TaskToDo task) => delete(tasks).delete(task);
}
