import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(body: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final txc = TextEditingController();
  bool isLoading = false;
  String? value;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  getAI(String prompt) async {
    if (prompt.isEmpty) {
      final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: Row(children: [
          Text('Escribi algo Salaminsky '),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.catching_pokemon)
        ]),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    setState(() {
      isLoading = true;
    });
    final model = GenerativeModel(
        model: 'gemini-pro', apiKey: "AIzaSyDvEjPCCAEkbcO3DBUcOcwveHpNDxE-XBE");

    final content = [
      Content.text(prompt),
    ];

    try {
      final response = await model.generateContent(content);
      setState(() {
        value = response.text;
        isLoading = false;
      });
    } catch (e) {
      final snackBar = SnackBar(
        backgroundColor: Colors.redAccent,
        content: Row(children: [
          Text('Error Papu '),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.car_crash)
        ]),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.asset("assets/icon/icon.png"),
                    title: TextField(
                      controller: txc,
                      decoration: const InputDecoration(
                        labelText: 'Escribi acá genio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    getAI(txc.value.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: !isLoading
                      ? Text('Enviar')
                      : CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                isLoading
                    ? Container(
                        child: Center(
                          child: AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _animation.value * 0.5 + 0.5,
                                  child: Transform.rotate(
                                    angle: _animation.value * 2 * 3.14,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                          child: Image.asset(
                                              "assets/icon/icon.png")),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    : SizedBox.shrink(),
                Text(value ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
