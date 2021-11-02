import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample_todo_list/page/todolistpage.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //비동기 메소드 사용시 추가해야함 위젯이 바인딩이 미리 완료되어 있게 만들어줌
  await Firebase.initializeApp(); //firebase 초기화
  runApp(const MyApp());
}

class Todo {
  bool isDone;
  String title;
  Todo(this.title, {this.isDone = false}); //isDone의 초기값은 false
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '할일 관리',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListPage(),
    );
  }
}
