import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/task_provider.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        if (provider.errorMessage.isEmpty) {
          return const SizedBox.shrink();
        }
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFFF4757).withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFFF6B6B),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  provider.errorMessage,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFF6B6B),
                    fontSize: 13,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                    provider.clearError();
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFFF6B6B),
                  size: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}