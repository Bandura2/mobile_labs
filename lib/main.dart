import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Command Input',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _outputNumber = 0;
  final TextEditingController _controller = TextEditingController();

  void _processCommand(String command) {
    setState(() {
      if (command.startsWith('rand')) {
        final number = int.tryParse(command.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
        _outputNumber = Random().nextInt(number + 1);
      } else if (command == 'add') {
        _counter += _outputNumber;
      } else if (command == 'reset') {
        _counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter command'),
              onSubmitted: (value) {
                _processCommand(value);
                _controller.clear();
              },
            ),
            const SizedBox(height: 20),
            Text('Random number: $_outputNumber', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text('Counter: $_counter', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
