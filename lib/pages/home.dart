import 'package:flutter/material.dart';
import 'package:todo_app/pages/post.dart';
import 'package:todo_app/pages/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [Todo(), Post()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Todo'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Post'),
        ],
      ),
    );
  }
}
