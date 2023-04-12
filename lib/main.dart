import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
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
  IconData? selectedIcon; // Define a nullable IconData variable to hold the selected icon
  final List<Todo> _todos = [
    //  to see a blank screen at start-up, comment the below 4 Todo items.
    //  I have just added them for debugging purpose
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
          title: const Text('New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
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
                items: [
                  DropdownMenuItem(
                    value: Icons.check_box_outline_blank,
                    child: Row(
                      children: const [
                        Icon(Icons.check_box_outline_blank),
                        SizedBox(width: 8.0),
                        Text("Check Box"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.email,
                    child: Row(
                      children: const [
                        Icon(Icons.email),
                        SizedBox(width: 8.0),
                        Text("Email"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.phone,
                    child: Row(
                      children: const [
                        Icon(Icons.phone),
                        SizedBox(width: 8.0),
                        Text("Phone"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.calendar_today,
                    child: Row(
                      children: const [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 8.0),
                        Text("Calendar"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.gamepad_outlined,
                    child: Row(
                      children: const [
                        Icon(Icons.gamepad_outlined),
                        SizedBox(width: 8.0),
                        Text("Gamepad"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.sports_soccer,
                    child: Row(
                      children: const [
                        Icon(Icons.sports_soccer),
                        SizedBox(width: 8.0),
                        Text("Soccer"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.list_alt,
                    child: Row(
                      children: const [
                        Icon(Icons.list_alt),
                        SizedBox(width: 8.0),
                        Text("List"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.money,
                    child: Row(
                      children: const [
                        Icon(Icons.money),
                        SizedBox(width: 8.0),
                        Text("Money"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.shopping_cart,
                    child: Row(
                      children: const [
                        Icon(Icons.shopping_cart),
                        SizedBox(width: 8.0),
                        Text("Shopping"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.work,
                    child: Row(
                      children: const [
                        Icon(Icons.work),
                        SizedBox(width: 8.0),
                        Text("Work"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Add'),
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
        title: const Text('Task Manager'),
      ),
      body: ListView.builder(
        itemBuilder: _buildTodoItem,
        itemCount: _todos.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
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
  const TodoDetails({super.key, required this.todo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row( // Add a Row for icon and title
              children: <Widget>[
                Icon(todo.icon), // Display the icon here
                const SizedBox(width: 32.0), // Add spacing between icon and title
                Text(
                  todo.title,
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16.0),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(todo.description),

            const SizedBox(height: 16.0),
            const Text(
              'Due Date',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(todo.dueDate),

            const SizedBox(height: 16.0),
            const Text(
              'Status',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(todo.done ? 'Done' : 'Not done'),
          ],
        ),
      ),
    );
  }
}
