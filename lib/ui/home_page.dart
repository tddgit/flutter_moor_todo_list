import 'package:flutter/material.dart';
import 'package:flutter_moor_todo_list/data/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Todo'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: _buildTaskList(context),
        ),
        NewTaskInput(),
      ]),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return StreamBuilder<List<TaskToDo>>(
      stream: database.watchAllTasks(),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              final itemTask = tasks[index];
              return _buildListItem(itemTask, database);
            });
      },
    );
  }

  Widget _buildListItem(TaskToDo itemTask, AppDatabase database) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteTaskToDo(itemTask),
        ),
      ],
      child: CheckboxListTile(
        title: Text(itemTask.name),
        subtitle: Text(
          itemTask.dueDate?.toString() ?? 'No date',
        ),
        value: itemTask.completed,
        onChanged: (newValue) => database.updateTaskToDo(
          itemTask.copyWith(completed: newValue),
        ),
      ),
    );
  }
}

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({Key? key}) : super(key: key);

  @override
  State<NewTaskInput> createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  late DateTime _newTaskDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return TextField();
  }

  Widget _buildDateButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(''),
    );
  }
}
