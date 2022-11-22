import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> createSensorPost() async {
  var url =
      Uri.https('arduino-unip.herokuapp.com', '/sensores', {'q': '{http}'});

  var headers = {
    "content-type": "application/json",
  };
  final Map<String, dynamic> userData = {"iluminacao": 90};
  final response = await http.post(
    Uri.parse('http://arduino-unip.herokuapp.com/sensores'),
    headers: headers,
    body: jsonEncode(userData),
  );
  http.Response respostaSensores;
  respostaSensores = await http.get(url);
  print(respostaSensores.body);
  print("status = ${respostaSensores.statusCode}");
  print(response.statusCode);

  if (response.statusCode == 204) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print("Body: " + response.body);
    return response;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}



class iluminacao extends StatefulWidget {
  const iluminacao({super.key});
  @override
  State<iluminacao> createState() => _iluminacaoState();
}

class _iluminacaoState extends State<iluminacao> {
  @override
  void initState() {
    // TODO: implement initState
    _recuperarDadosServidor();
  }

  _recuperarDadosServidor() async {
    print("texto test");
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/sensores', {'q': '{http}'});
    http.Response respostaSensores;
    respostaSensores = await http.get(url);
    print(respostaSensores.body);
    print("status = ${respostaSensores.statusCode}");
    if (respostaSensores.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(respostaSensores.body);
      double porcentagem;
      int iluminacao = retorno["iluminacao"];
      setState(
        () {
          porcentagem = iluminacao / 9;
          valorSlider = iluminacao / 9;
          _respostaSensorIluminacao = porcentagem.toStringAsPrecision(3);
        },
      );
    } else {
      print(
          "Resposta ruim do servidor com código: ${respostaSensores.statusCode}");
    }
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.purple, Colors.white],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 320.0, 80.0));
  List colors = [Colors.amber, Colors.blue];
  String textoBotao = "Ligado";
  String _respostaSensorIluminacao = "";
  int valorLigado = 0;
  int valorDesligado = 0;
  double valorSlider = 0;

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
        child: SingleChildScrollView(
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
                    width: MediaQuery.of(context).size.width - 50,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 40),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.grey,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              //!alterar com lógica

                              color: colors[0],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const Image(
                          image: AssetImage('images/camaleao.png'),
                          height: 100,
                          width: 100,
                        ),
                        Container(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                color: Colors.white,
                              ),
                              Text(
                                _respostaSensorIluminacao,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                '%',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'images/imagem3d.jpg',
                      scale: 4,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20, left: 20, right: 10, bottom: 20),
                    padding: const EdgeInsets.all(10),
                    width: 330,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(2, 3),
                            color: Color.fromARGB(163, 171, 10, 240),
                          )
                        ],
                        color: Color.fromARGB(255, 23, 18, 27)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Luz manual",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Switch(
                              value: false,
                              onChanged: null,
                              inactiveTrackColor: Colors.grey,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Economia inteligente",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Switch(
                              value: false,
                              onChanged: null,
                              inactiveTrackColor: Colors.grey,
                            )
                          ],
                        ),
                        Text('${_respostaSensorIluminacao}%',
                            style: TextStyle(
                              foreground: Paint()..shader = linearGradient,
                              fontSize: 50,
                              fontWeight: FontWeight.w700,
                            )),
                        const Text('Iluminação de ativação',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            )),
                        Slider.adaptive(
                          activeColor: Color.fromARGB(255, 185, 59, 207),
                          min: 0,
                          max: 100,
                          value: valorSlider,
                          onChanged: (double value) => {value++},
                          thumbColor: Color.fromARGB(255, 185, 59, 207),
                          inactiveColor: Colors.grey,
                          divisions: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "0%",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "100%",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60))),
                          width: 270,
                          height: 80,
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                padding: MaterialStatePropertyAll<
                                        EdgeInsetsGeometry>(
                                    EdgeInsets.only(top: 20)),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 199, 53, 224)),
                              ),
                              onPressed: () {
                                setState(() {
                                  createSensorPost();
                                });
                              },
                              child: Column(
                                //!alterar
                                children: [
                                  Icon(
                                    Icons.flash_on,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    textoBotao,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
