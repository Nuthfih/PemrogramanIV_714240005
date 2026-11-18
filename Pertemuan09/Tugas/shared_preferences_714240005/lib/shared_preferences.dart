import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyShared extends StatefulWidget {
  const MyShared({super.key});

  @override
  State<MyShared> createState() => _MySharedState();
}

class _MySharedState extends State<MyShared> {
  late SharedPreferences prefs;
  final _dataController = TextEditingController();
  final _getDataController = TextEditingController();

  @override
  void dispose() {
    _dataController.dispose();
    _getDataController.dispose();
    super.dispose();
  }

  void save() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', _dataController.text);
  }

  void getValue() async {
    prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _getDataController.text = prefs.getString('data').toString();
    });
  }

  void deleteValue() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('data');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preferences'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _dataController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _getDataController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: getValue,
                  child: const Text('Get Value'),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: deleteValue,
                  child: const Text('Delete Value'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
