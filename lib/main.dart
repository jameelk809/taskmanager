import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager App',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  TextEditingController dateInputController = TextEditingController();
  final List<Todo> _todos = [
    Todo(
        title: 'Todo',
        description: 'Do something important',
        dueDate: '15 April 2023',
        icon: Icons.check_circle),
    Todo(
        title: 'Email',
        description: 'Send an important email',
        dueDate: '16 April 2023',
        icon: Icons.email),
    Todo(
        title: 'Phone',
        description: 'Make an important phone call',
        dueDate: '17 April 2023',
        icon: Icons.phone),
    Todo(
        title: 'Meeting',
        description: 'Attend an important meeting',
        dueDate: '18 April 2023',
        icon: Icons.people),
  ];

  void _addTodo() async {
    final newTodo = await showDialog<Todo>(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';
        String dueDate = '';
        IconData icon = Icons.check_box_outline_blank;

        return AlertDialog(
          title: Text('New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Date',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1)),
                ),
                controller: dateInputController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050));

                  if (pickedDate != null) {
                    dateInputController.text =
                        DateFormat('dd MMMM yyyy').format(pickedDate);
                    dueDate = dateInputController.text;
                  }
                },
              ),
              DropdownButton<IconData>(
                value: icon,
                onChanged: (value) => icon = value!,
                items: const [
                  DropdownMenuItem(
                    value: Icons.check_box_outline_blank,
                    child: Icon(Icons.check_box_outline_blank),
                  ),
                  DropdownMenuItem(
                    value: Icons.email,
                    child: Icon(Icons.email),
                  ),
                  DropdownMenuItem(
                    value: Icons.phone,
                    child: Icon(Icons.phone),
                  ),
                  DropdownMenuItem(
                    value: Icons.calendar_today,
                    child: Icon(Icons.calendar_today),
                  ),
                  DropdownMenuItem(
                    value: Icons.gamepad_outlined,
                    child: Icon(Icons.gamepad_outlined),
                  ),
                  DropdownMenuItem(
                    value: Icons.sports_soccer,
                    child: Icon(Icons.sports_soccer),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () => Navigator.of(context).pop(Todo(
                title: title,
                description: description,
                dueDate: dueDate,
                icon: icon,
              )),
            ),
          ],
        );
      },
    );
    if (newTodo != null) {
      setState(() {
        _todos.add(newTodo);
      });
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _markAsDone(int index) {
    setState(() {
      _todos[index].done = true;
    });
  }

  Widget _buildTodoItem(BuildContext context, int index) {
    final todo = _todos[index];

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _removeTodo(index),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Done',
          color: Colors.green,
          icon: Icons.done,
          onTap: () => _markAsDone(index),
        ),
      ],
      child: ListTile(
        leading: Icon(todo.icon),
        title: Text(todo.title),
        subtitle: Text(todo.description),
        trailing: Text(todo.dueDate),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoDetails(todo: todo)),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager App'),
      ),
      body: ListView.builder(
        itemBuilder: _buildTodoItem,
        itemCount: _todos.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}
class Todo {
  final String title;
  final String description;
  final String dueDate;
  final IconData icon;
  bool done;

  Todo({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.icon,
    this.done = false,
  });
}

class TodoDetails extends StatelessWidget {
  final Todo todo;

  TodoDetails({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Description',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(todo.description),
            SizedBox(height: 16.0),
            const Text(
              'Due Date',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(todo.dueDate),
            SizedBox(height: 16.0),
            const Text(
              'Status',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(todo.done ? 'Done' : 'Not done'),
          ],
        ),
      ),
    );
  }
}

