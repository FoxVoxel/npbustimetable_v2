import 'package:flutter/material.dart';
import 'package:npbustimetable_v2/src/screens/HomeScreen.dart';

// Запуск приложения
void main() => runApp(AppInit());

// Главный класс приложения для отображения визуальной части и запуска HomeScreen
class AppInit extends StatelessWidget {
  const AppInit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
} 
