import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/services/task_service.dart';
import 'package:task_manager_project/ui/widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  final List<TaskStatusCount> taskCounts;
  final VoidCallback onRefresh;

  const CompletedTaskScreen({
    required this.taskCounts,
    required this.onRefresh,
    super.key,
  });

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
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
      final response = await TaskService.getTasksByStatus('Completed');

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
            ? const Center(child: CircularProgressIndicator())
            : tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.task_alt, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No completed tasks found',
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
                    chipColor: Colors.green,
                    onUpdate: _onTaskUpdate,
                  );
                },
              ),
      ),
    );
  }
}
