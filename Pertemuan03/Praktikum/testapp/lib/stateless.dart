import 'package:flutter/material.dart';

class iniStateless extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),      
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            Center(child: Text('Hello World')),
            ElevatedButton(onPressed: () {}, child: Text('Click Me'))
            ]
        ),
      ),
    );
  }
}