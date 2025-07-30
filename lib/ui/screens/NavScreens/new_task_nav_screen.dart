import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/services/task_service.dart';
import 'package:task_manager_project/ui/widgets/task_card.dart';

class NewTaskNavScreen extends StatefulWidget {
  final List<TaskStatusCount> taskCounts;
  final VoidCallback onRefresh;

  const NewTaskNavScreen({
    required this.taskCounts,
    required this.onRefresh,
    super.key,
  });

  @override
  State<NewTaskNavScreen> createState() => _NewTaskNavScreenState();
}

class _NewTaskNavScreenState extends State<NewTaskNavScreen> {
  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await TaskService.getTasksByStatus('New');

      if (!mounted) return;

      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'];
        setState(() {
          tasks = data.map((item) => Task.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          tasks = [];
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        tasks = [];
        isLoading = false;
      });
    }
  }

  void _onTaskUpdate() {
    _loadTasks();
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _loadTasks();
          widget.onRefresh();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No new tasks found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    task: tasks[index],
                    chipColor: Colors.blue,
                    onUpdate: _onTaskUpdate,
                  );
                },
              ),
      ),
    );
  }
}
