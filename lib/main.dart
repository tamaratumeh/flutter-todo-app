import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/task_provider.dart';
import 'ui/home.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF34348D),
            secondary: Color(0xFF34348D),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 162, 167, 182),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                color: const Color.fromARGB(255, 162, 167, 182),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: child,
              ),
            ),
          );
        },
        home: const HomeScreen(),
      ),
    );
  }
}
