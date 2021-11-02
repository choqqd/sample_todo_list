import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sample_todo_list/main.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  var _todoController = TextEditingController(); //input 문자열의 컨트롤러

  @override
  void dispose() {
    super.dispose();
    _todoController.dispose();
  }

  /* Firestore의 구조는 SQL 데이터 베이스와는 다른 테이블 구조
  *  Collection 안에 Document들이 저장. Document안에 데이터를 저장
  *  Document안에는 Key-Value구조로 데이터 저장됨
  */
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final todo = Todo(doc['title'], isDone: doc['isDone']);
    return ListTile(
      onTap: () => _toggleTodo(doc), //리스트를 클릭시 업데toggleTodo가 작동됨
      title: Text(
        todo.title,
        style: todo.isDone //true일 경우 가운데줄 표시
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic,
              )
            : null, //false일 경우 아무 스타일 없음
      ),
      trailing: IconButton(
        //텍스트 뒤에 나타나는 widget
        onPressed: () => _deleteTodo(doc),
        icon: Icon(
          Icons.delete_forever,
        ),
      ),
    );
  }

  //할 일 추가 메서드
  void _addTodo(Todo todo) {
    FirebaseFirestore.instance
        .collection('todo')
        .add({'title': todo.title, 'isDone': todo.isDone});
    _todoController.text = '';
  }

  //할 일 삭제 메서드
  void _deleteTodo(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();
  }

  //할 일 완료/미완료 메서드
  void _toggleTodo(DocumentSnapshot doc) {
    FirebaseFirestore.instance
        .collection('todo')
        .doc(doc.id)
        .update({'isDone': !doc['isDone']});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('남 은 할일'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _addTodo(Todo(_todoController.text)),
                  child: Text('추가'),
                )
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('todo').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final documents = snapshot.data!.docs;
                  return Expanded(
                    child: ListView(
                      children: documents
                          .map((doc) => _buildItemWidget(doc))
                          .toList(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
