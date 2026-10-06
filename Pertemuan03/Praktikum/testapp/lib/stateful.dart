import 'package:flutter/material.dart';

class iniStateful extends StatefulWidget {
  const new({super.key});

  @override
  State<iniStateful> createState() => _iniStatefulState();
}

class _iniStatefulState extends State<iniStateful> {
int counter = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(onPressed: () {setState(() {counter++;});}, child: Text('Click Me : $counter'))
        )
      )
    );
  }
}