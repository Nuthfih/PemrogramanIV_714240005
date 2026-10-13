import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(textAlign: TextAlign.center, "mainAxisAlignment.spaceEvenly"),
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
              Icon(Icons.share),
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
            ],
          ),
          const SizedBox(height: 20),
          Text(textAlign: TextAlign.center, "mainAxisAlignment.spaceAround"),
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
              Icon(Icons.share),
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
            ],
          ),
          const SizedBox(height: 20),
          Text(textAlign: TextAlign.center, "mainAxisAlignment.spaceBetween"),
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
              Icon(Icons.share),
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
            ],
          ),
          const SizedBox(height: 20),
          Text(textAlign: TextAlign.center, "mainAxisAlignment.start"),
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
              Icon(Icons.share),
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
            ],
          ),
          const SizedBox(height: 20),
          Text(textAlign: TextAlign.center, "mainAxisAlignment.center"),
          Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              Icon(Icons.share),
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
            ],
          ),
          const SizedBox(height: 20),
          Text(textAlign: TextAlign.center, "mainAxisAlignment.end"),
          Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
              Icon(Icons.share),
              Icon(Icons.thumb_up),
              Icon(Icons.thumb_down),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Colors.lightBlue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text('Homepage')),
            ListTile(title: Text('Settings')),
          ],
        ),
      ),
      body: MyContainer(),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ]),
    );
  }
}
