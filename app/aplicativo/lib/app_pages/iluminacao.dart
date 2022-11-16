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
        title: const Center(
          child: Text("Iluminação"),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 1, 2, 19),
      ),
      backgroundColor: const Color.fromARGB(255, 1, 2, 19),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topLeft,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 1, 2, 19),
              Color.fromARGB(255, 3, 3, 39),
            ])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  "Cor e Iluminação Atual",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(2, 3),
                        color: Color.fromARGB(187, 9, 98, 146),
                      )
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 8, 12, 87),
                          Color.fromARGB(225, 12, 12, 143),
                        ]),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: 360,
                  height: 60,
                  child: Row(
                    children: [
                      Container(
                      ),
                      Image(image: AssetImage('images/color-circle.png'),)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
