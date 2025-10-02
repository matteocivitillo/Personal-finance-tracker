import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('Total balance and transactions'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()=> Navigator.pushNamed(context, '/add'),
          child: Icon(Icons.add),
      ),
    );
  }
}