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
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 1, 2, 19),
              Color.fromARGB(255, 3, 3, 39),
            ])),
        child: Column(
          children: [
            Text("Cor e Iluminação Atual",
            style: TextStyle(color: Colors.white, fontSize: 20),),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              width: 300,
              height: 66,
            ),
          ],
        ),
      ),
    );
  }
}
