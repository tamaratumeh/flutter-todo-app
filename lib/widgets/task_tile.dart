import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_dto.dart';
import '../providers/task_provider.dart';
import 'edit_task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;
  final bool showCheckbox;

  const TaskTile({
    super.key,
    required this.task,
    required this.index,
    this.showCheckbox = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 50)),
      builder: (_, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _card(context),
      ),
    );
  }

  Widget _card(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TaskProvider>().toggleTask(task.id!);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: task.done
                ? const Color(0xFF34348D)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            showCheckbox ? _checkbox() : _icon(),
            const SizedBox(width: 16),
            Expanded(child: _content()),
            _actions(context),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF34348D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.assignment_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _checkbox() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF34348D).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: task.done
          ? const Icon(
              Icons.check_rounded,
              color: Color(0xFF34348D),
              size: 28,
            )
          : null,
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D42),
            decoration:
                task.done ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 4),
        if (task.createdAt != null)
          Text(
            _date(task.createdAt!),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => EditTaskDialog(task: task),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDFE9F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.edit_rounded,
              size: 18,
              color: Color(0xFF34348D),
            ),
          ),
        ),

        const SizedBox(width: 8),

        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Task?'),
                content: Text('Delete "${task.title}" ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<TaskProvider>().deleteTask(task.id!);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: Colors.red.shade400,
            ),
          ),
        ),
      ],
    );
  }

  String _date(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';

    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];

    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}