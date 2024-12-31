import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/home_page.dart';
import 'package:todo/providers/post_provider.dart';
import 'package:todo/providers/task_list_provider.dart';
import 'package:todo/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final taskListModel = TaskListModel();
  await taskListModel.initializeDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => taskListModel),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final ColorScheme kColorScheme =
        ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
        brightness: Brightness.dark, seedColor: Colors.deepPurple);

    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData().copyWith(colorScheme: kColorScheme),
      darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorScheme),
      themeMode: themeProvider.themeMode == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}
