import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // constructor
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _inputValue = '';

  void _getListagemAPI() async {
    try {
      final response = await http.get(
        Uri.https(Env.apiEndpoint, Env.apiParams),
        headers: {
          'authorization': 'Bearer ${Env.apiKey}',
          'content-type': 'application/json:charset=utf-8' },
      );
      print(response.body);
    } catch (e) {
      print('Error fetching API: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getListagemAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Wello World',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            const Text(
              'Welcome my first project in flutter',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
                'Input Value: $_inputValue',
                style: const TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                style: const TextStyle(color: Colors.black54),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _inputValue = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
