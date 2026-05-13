import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task.dart';
import '../widgets/stats_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            const StatsCard(),
            const SizedBox(height: 8),
            const ErrorBanner(),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Tasks',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF34348D),
              letterSpacing: -0.5,
            ),
          ),
          GestureDetector(
            onTap: _showAddSheet,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF34348D),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34348D).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: Colors.grey.shade500,
          unselectedItemColor: const Color(0xFF34348D),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 28),
              label: 'All',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_rounded, size: 28),
              label: 'Pending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline_rounded, size: 28),
              label: 'Done',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        if (provider.status == TaskStatus.loading &&
            provider.tasks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF34348D),
            ),
          );
        }

        List tasks;
        String emptyMsg;

        if (_currentIndex == 0) {
          tasks = provider.tasks;
          emptyMsg = 'No tasks yet.\nTap + to add your first task!';
        } else if (_currentIndex == 1) {
          tasks = provider.tasks.where((t) => !t.done).toList();
          emptyMsg = 'No pending tasks!\nYou\'re all caught up';
        } else {
          tasks = provider.tasks.where((t) => t.done).toList();
          emptyMsg = 'No completed tasks yet.\nStart checking things off!';
        }

        return _TaskListView(
          tasks: tasks,
          emptyLabel: emptyMsg,
          showCheckbox: _currentIndex != 0,
        );
      },
    );
  }
}

class _TaskListView extends StatelessWidget {
  final List tasks;
  final String emptyLabel;
  final bool showCheckbox;

  const _TaskListView({
    required this.tasks,
    required this.emptyLabel,
    required this.showCheckbox,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return EmptyState(message: emptyLabel);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        return TaskTile(
          task: tasks[index],
          index: index,
          showCheckbox: showCheckbox,
        );
      },
    );
  }
}