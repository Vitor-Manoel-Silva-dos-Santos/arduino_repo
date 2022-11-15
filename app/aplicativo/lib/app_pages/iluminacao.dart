
import 'package:flutter/material.dart';

class iluminacao extends StatefulWidget {
  const iluminacao({super.key});

  @override
  State<iluminacao> createState() => _iluminacaoState();
}

class _iluminacaoState extends State<iluminacao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Iluminação"),),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 1, 2, 19),
      ),
      backgroundColor: const Color.fromARGB(255, 1, 2, 19),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 1, 2, 19),
                Color.fromARGB(255, 3, 3, 39),
            ])),
            child: Row(
              children: [
                Container(
                  color: Colors.white,
                  width: 30,
                  height: 30,
                )
              ],
            ),
      ),
    );
  }
}
