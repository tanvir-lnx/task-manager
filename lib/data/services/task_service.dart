import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/network/network_service.dart';
import 'package:task_manager_project/data/utils/api_config.dart';

class TaskService {
  static Future<Map<String, dynamic>> createTask(Task task) async {
    return await NetworkService.post(
      url: '${ApiConfig.baseUrl}${ApiConfig.createTask}',
      body: task.toJson(),
      requiresAuth: true,
    );
  }

  static Future<Map<String, dynamic>> deleteTask(String taskId) async {
    return await NetworkService.get(
      url: '${ApiConfig.baseUrl}${ApiConfig.deleteTask}/$taskId',
      requiresAuth: true,
    );
  }

  static Future<Map<String, dynamic>> updateTaskStatus(String taskId, String status) async {
    return await NetworkService.get(
      url: '${ApiConfig.baseUrl}${ApiConfig.updateTaskStatus}/$taskId/$status',
      requiresAuth: true,
    );
  }

  static Future<Map<String, dynamic>> getTasksByStatus(String status) async {
    return await NetworkService.get(
      url: '${ApiConfig.baseUrl}${ApiConfig.listTaskByStatus}/$status',
      requiresAuth: true,
    );
  }

  static Future<Map<String, dynamic>> getTaskStatusCount() async {
    return await NetworkService.get(
      url: '${ApiConfig.baseUrl}${ApiConfig.taskStatusCount}',
      requiresAuth: true,
    );
  }
}