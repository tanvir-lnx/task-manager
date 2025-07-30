import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/task_model.dart';
import 'package:task_manager_project/data/services/task_service.dart';
import 'package:task_manager_project/ui/screens/NavScreens/canceled_task_screen.dart';
import 'package:task_manager_project/ui/screens/NavScreens/completed_task_screen.dart';
import 'package:task_manager_project/ui/screens/NavScreens/in_progress_task_screen.dart';
import 'package:task_manager_project/ui/screens/NavScreens/new_task_nav_screen.dart';
import 'package:task_manager_project/ui/screens/new_task_screen.dart';
import 'package:task_manager_project/ui/widgets/const_app_bar.dart';

class MainNavBarHolder extends StatefulWidget {
  const MainNavBarHolder({super.key});
  static const String name = '/main-na-bar-holder';

  @override
  State<MainNavBarHolder> createState() => _MainNavBarHolderState();
}

class _MainNavBarHolderState extends State<MainNavBarHolder> {
  late List<Widget> _navScreens;
  int _selectedIndex = 0;
  List<TaskStatusCount> taskCounts = [];
  bool isLoadingCounts = true;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
    _loadTaskCounts();
  }

  void _initializeScreens() {
    _navScreens = [
      NewTaskNavScreen(taskCounts: taskCounts, onRefresh: _loadTaskCounts),
      CompletedTaskScreen(taskCounts: taskCounts, onRefresh: _loadTaskCounts),
      CanceledTaskScreen(taskCounts: taskCounts, onRefresh: _loadTaskCounts),
      InProgressTaskScreen(taskCounts: taskCounts, onRefresh: _loadTaskCounts),
    ];
  }

  void _loadTaskCounts() async {
    setState(() {
      isLoadingCounts = true;
    });

    try {
      final response = await TaskService.getTaskStatusCount();
      
      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> data = response['data'];
        setState(() {
          taskCounts = data.map((item) => TaskStatusCount.fromJson(item)).toList();
          isLoadingCounts = false;
        });
        _initializeScreens();
      } else {
        setState(() {
          taskCounts = [];
          isLoadingCounts = false;
        });
      }
    } catch (e) {
      setState(() {
        taskCounts = [];
        isLoadingCounts = false;
      });
    }
  }

  int _getCountForStatus(String status) {
    final count = taskCounts.firstWhere(
      (element) => element.status == status,
      orElse: () => TaskStatusCount(status: status, count: 0),
    );
    return count.count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ConstAppBar(),
      ),
      body: isLoadingCounts
          ? Center(child: CircularProgressIndicator())
          : _navScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: 'New (${_getCountForStatus('New')})',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Completed (${_getCountForStatus('Completed')})',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Canceled (${_getCountForStatus('Canceled')})',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Progress (${_getCountForStatus('Progress')})',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, NewTaskScreen.name);
          if (result == true) {
            _loadTaskCounts();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}