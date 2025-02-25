import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/screens/edit_task_screen.dart';
import 'package:todo_app/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];

  void _addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
      saveTasks();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks();
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      saveTasks();
    });
  }

  // void _editTask(int index, String title) {
  //   setState(() {
  //     tasks[index].title = title;
  //   });
  // }

  void _editTask(int index) async {
    if (tasks[index].isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Completed Task can't be edited")));
      return;
    }

    final updatedResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditTaskScreen(
                  task: tasks[index],
                )));

    if (updatedResult is String && updatedResult.isNotEmpty) {
      setState(() {
        tasks[index].title = updatedResult;
        saveTasks();
      });
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      setState(() {
        tasks.clear();
        tasks.addAll(tasksList.map((e) => Task.fromJson(e)).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskList',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        elevation: 2,
        shadowColor: Colors.grey.shade50,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks added yet!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: tasks[index],
                  onDelete: () => _deleteTask(index),
                  onToggleComplete: () => _toggleComplete(index),
                  onEdit: () => _editTask(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result is String && result.isNotEmpty) {
            _addTask(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
