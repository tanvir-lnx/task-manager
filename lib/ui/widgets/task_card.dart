import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/services/task_service.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Color chipColor;
  final VoidCallback? onUpdate;

  const TaskCard({
    required this.task,
    required this.chipColor,
    this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            task.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                style: const TextStyle(color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                'Date: ${_formatDate(task.createdDate)}',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Chip(
                    backgroundColor: chipColor,
                    shape: RoundedRectangleBorder(side: BorderSide.none),
                    label: Text(task.status, style: TextStyle(color: Colors.white)),
                  ),
                  Spacer(),
                  if (task.status != 'Completed')
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert),
                      onSelected: (value) => _handleStatusChange(context, value),
                      itemBuilder: (context) => [
                        if (task.status != 'Progress')
                          PopupMenuItem(value: 'Progress', child: Text('In Progress')),
                        if (task.status != 'Completed')
                          PopupMenuItem(value: 'Completed', child: Text('Completed')),
                        if (task.status != 'Canceled')
                          PopupMenuItem(value: 'Canceled', child: Text('Canceled')),
                      ],
                    ),
                  IconButton(
                    onPressed: () => _deleteTask(context),
                    icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  void _handleStatusChange(BuildContext context, String newStatus) async {
    
    try {
      final response = await TaskService.updateTaskStatus(task.id!, newStatus);
      
      if (response['status'] == 'success') {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
        onUpdate?.call();
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteTask(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await TaskService.deleteTask(task.id!);
        if (!context.mounted) return;
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          onUpdate?.call();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete task'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}