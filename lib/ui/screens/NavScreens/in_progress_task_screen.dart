import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/services/task_service.dart';
import 'package:task_manager_project/ui/widgets/task_card.dart';

class InProgressTaskScreen extends StatefulWidget {
  final List<TaskStatusCount> taskCounts;
  final VoidCallback onRefresh;

  const InProgressTaskScreen({
    required this.taskCounts,
    required this.onRefresh,
    super.key,
  });

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
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
      final response = await TaskService.getTasksByStatus('Progress');

      if (!mounted) return;

      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'];
        if (!mounted) return;
        setState(() {
          tasks = data.map((item) => Task.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        if (!mounted) return;
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
    if (!mounted) return;
    _loadTasks();
    if (mounted) widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (!mounted) return;
          _loadTasks();
          if (mounted) widget.onRefresh();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : tasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No tasks in progress found',
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
                        chipColor: Colors.orange,
                        onUpdate: _onTaskUpdate,
                      );
                    },
                  ),
      ),
    );
  }
}
