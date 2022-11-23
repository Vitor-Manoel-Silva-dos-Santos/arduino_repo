import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:aplicacao_unip/appalarm/modules/views/alarm_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class MultiSwitch extends StatefulWidget {
  const MultiSwitch({super.key});

  @override
  State<MultiSwitch> createState() => _MultiSwitchState();
}

class _MultiSwitchState extends State<MultiSwitch> {
  double _sliderValueTU = 20.0; //temperaturainicialumidificador
  double _sliderValueTV = 20.0; //temperaturainicialventilador
  double _sliderValueTJ = 20.0; //temperaturainicialjanela
  double _sliderValueUU = 50.0; //humidadeinicialhumidificador
  double _sliderValueUV = 50.0; //humidadeinicialventilador
  double _sliderValueUJ = 50.0; //humidadeinicialjanela

  bool _val1 = true;
  bool _val2 = true;
  bool _val3 = true;

  int _controlval1 = 0;
  int _controlval2 = 0;
  int _controlval3 = 0;

  bool _energia1 = true;
  bool _energia2 = true;
  bool _energia3 = true;

  String _respostaTemperatura = "0";
  double _valorRespostaTemperatura = 0;
  int _respostaUmidade = 0;

  _recuperarDadosServidor() async {
    print("texto test");
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/sensores', {'q': '{http}'});
    http.Response respostaSensores;
    respostaSensores = await http.get(url);

    print("status = ${respostaSensores.statusCode}");
    if (respostaSensores.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(respostaSensores.body);
      int umidade = retorno["umidade"];
      int temperatura = retorno["temperatura"];
      print("temperatura = $temperatura");
      setState(() {
        _valorRespostaTemperatura = temperatura.toDouble();
        _respostaTemperatura = "$temperatura";
      });
      print("umidade = $umidade");
      setState(() {
        _respostaUmidade = umidade;
      });
    } else {
      print(
          "Resposta ruim do servidor com código: ${respostaSensores.statusCode}");
    }
  }

  _botoesServidor() async {
    print("texto test botao");
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/motores', {'q': '{http}'});
    http.Response respostaBotoes;
    respostaBotoes = await http.get(url);

    print("status = ${respostaBotoes.statusCode}");
    if (respostaBotoes.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(respostaBotoes.body);
      bool botao1 = retorno["janela"]["manual"];
      bool botao2 = retorno["ventilador"]["manual"];
      bool botao3 = retorno["umidificador"]["manual"];
      print("botao1 = $botao1");
      setState(() {
        _val1 = botao1;
        if (botao1 == true) {
          _controlval1 = 1;
        } else {
          _controlval1 = 0;
        }

        print("valor1 servidor = ${_val1}");
      });
      print("botao2 = $botao2");
      setState(() {
        _val2 = botao2;
      });
      print("botao3 = $botao3");
      setState(() {
        _val3 = botao3;
      });
    } else {
      print(
          "Resposta ruim do servidor com código: ${respostaBotoes.statusCode}");
    }
  }

  _dadosEnergia() async {
    print("texto test botao");
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/motores', {'q': '{http}'});
    http.Response respostaBotoes;
    respostaBotoes = await http.get(url);

    print("status = ${respostaBotoes.statusCode}");
    if (respostaBotoes.statusCode == 200) {
      Map<String, dynamic> retorno = json.decode(respostaBotoes.body);
      bool energia1 = retorno["janela"]["aberta"];
      bool energia2 = retorno["ventilador"]["ligado"];
      bool energia3 = retorno["umidificador"]["ligado"];
      print("energia1 = $energia1");
      setState(() {
        _energia1 = energia1;
      });
      print("botao2 = $energia2");
      setState(() {
        _energia2 = energia2;
      });
      print("botao3 = $energia3");
      setState(() {
        _energia3 = energia3;
      });
    } else {
      print(
          "Resposta ruim do servidor com código: ${respostaBotoes.statusCode}");
    }
  }

  Future<http.Response> createJanelaPost(
      {double temperatura = 20,
      double umidade = 50,
      bool versao = true}) async {
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/motores', {'q': '{http}'});

    var headers = {
      "content-type": "application/json",
    };
    final Map<String, dynamic> userData = {
      "janela": <String, dynamic>{
        "manual": versao,
        "temperatura_de_ativacao": temperatura,
        "umidade_de_ativacao": umidade
      }
    };
    final response = await http.post(
      Uri.parse('https://arduino-unip.herokuapp.com/motores'),
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

  Future<http.Response> createVentiladorPost(
      {double temperatura = 20,
      double umidade = 50,
      bool versao = true}) async {
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/motores', {'q': '{http}'});

    var headers = {
      "content-type": "application/json",
    };
    final Map<String, dynamic> userData = {
      "ventilador": <String, dynamic>{
        "manual": versao,
        "temperatura_de_ativacao": temperatura,
        "umidade_de_ativacao": umidade
      }
    };
    final response = await http.post(
      Uri.parse('https://arduino-unip.herokuapp.com/motores'),
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

  Future<http.Response> createUmidificadorPost(
      {double temperatura = 20,
      double umidade = 50,
      bool versao = true}) async {
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/motores', {'q': '{http}'});

    var headers = {
      "content-type": "application/json",
    };
    final Map<String, dynamic> userData = {
      "umidificador": <String, dynamic>{
        "manual": versao,
        "temperatura_de_ativacao": temperatura,
        "umidade_de_ativacao": umidade
      }
    };
    final response = await http.post(
      Uri.parse('https://arduino-unip.herokuapp.com/motores'),
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

  @override
  void initState() {
    _recuperarDadosServidor();
    _dadosEnergia();
    _botoesServidor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Image(
                    image: AssetImage('images/nuvem.png'),
                    width: 110,
                    height: 110,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color(0xff5b0060),
                          Color(0xff1f005c),
                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              color: Colors.white,
                              Icons.thermostat,
                              size: 40,
                            ),
                            Text(
                              _respostaTemperatura,
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.white),
                            ),
                            const Text(
                              "°C",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "$_respostaUmidade",
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.white),
                            ),
                            const Text(
                              "%",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            Icon(
                                color: Colors.white,
                                Icons.water_drop_outlined,
                                size: 40)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Janela',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            Switch(
                              value: _val1,
                              activeColor: Color.fromARGB(255, 252, 116, 106),
                              onChanged: (bool state) {
                                setState(() {
                                  print("botaswitch");
                                  _val1 = state;
                                  if (_val1 == true) {
                                    createJanelaPost();
                                  }
                                });
                              },
                            ),
                            Text(_val1 == true ? "Manual" : "Automático",
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_sliderValueTJ.round().toString()}°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Temperatura ambiente',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider.adaptive(
                    min: 0.0,
                    max: 40.0,
                    value: _sliderValueTJ,
                    divisions: 10,
                    //labels: _sliderRangeLabels,
                    onChanged: (double val) {
                      setState(() {
                        _sliderValueTJ = val;
                        print("botaoslide1: ${_sliderValueTJ}");
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '40°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_sliderValueUJ.round().toString()}%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Umidade máxima',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider.adaptive(
                    min: 0.0,
                    max: 100.0,
                    value: _sliderValueUJ,
                    divisions: 10,
                    //labels: _sliderRangeLabels,
                    onChanged: (double val) {
                      setState(() {
                        _sliderValueUJ = val;
                        print("botaoslide2: ${_sliderValueUJ}");
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '100%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFCCBC),
                        ),
                        onPressed: !_val1
                            ? () {
                                setState(() {
                                  print("onPressed");
                                  createJanelaPost(
                                      temperatura: _sliderValueTJ,
                                      umidade: _sliderValueUJ,
                                      versao: _val1);
                                  print(_sliderValueTJ);
                                  print(_sliderValueUJ);
                                });
                              }
                            : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.window, color: Colors.black),
                            Text(
                              _energia3 == true ? 'Aberta' : 'Fechada',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //SEGUNDO CONTEINER VENTILADOR

            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Ventilador',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            Switch(
                              value: _val2,
                              activeColor: Color.fromARGB(255, 47, 30, 199),
                              onChanged: (bool state) {
                                setState(() {
                                  print("botaswitch");
                                  _val2 = state;
                                  if (_val2 == true) {
                                    createVentiladorPost();
                                  }
                                });
                              },
                            ),
                            Text(_val2 == true ? "Manual" : "Automático",
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_sliderValueTV.round().toString()}°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Temperatura ambiente',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider.adaptive(
                    min: 0.0,
                    max: 40.0,
                    value: _sliderValueTV,
                    divisions: 10,
                    //labels: _sliderRangeLabels,
                    onChanged: (double val) {
                      setState(() {
                        _sliderValueTV = val;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '40°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_sliderValueUV.round().toString()}%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Umidade máxima',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider.adaptive(
                    min: 0.0,
                    max: 100.0,
                    value: _sliderValueUV,
                    divisions: 10,
                    //labels: _sliderRangeLabels,
                    onChanged: (double val) {
                      setState(() {
                        _sliderValueUV = val;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '100%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFB3E5FC),
                        ),
                        onPressed: !_val2
                            ? () {
                                setState(() {
                                  print("onPressed");
                                  createVentiladorPost(
                                      temperatura: _sliderValueTV,
                                      umidade: _sliderValueUV,
                                      versao: _val2);
                                  print(_sliderValueTV);
                                  print(_sliderValueUV);
                                });
                              }
                            : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('images/ventilador.png'),
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              _energia2 == true ? 'Ligado' : 'Desligado',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //TERCEIRO CONTEINER UMIDIFICADOR

            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFA738), Color(0xFFFFE130)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Umidificador',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            Switch(
                              value: _val3,
                              activeColor: Color.fromARGB(255, 226, 210, 68),
                              onChanged: (bool state) {
                                setState(() {
                                  print("botaswitch");
                                  _val3 = state;
                                  if (_val3 == true) {
                                    createUmidificadorPost();
                                  }
                                });
                              },
                            ),
                            Text(_val3 == true ? "Manual" : "Automático",
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_sliderValueTU.round().toString()}°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Temperatura ambiente',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider.adaptive(
                    min: 0.0,
                    max: 40.0,
                    value: _sliderValueTU,
                    divisions: 10,
                    //labels: _sliderRangeLabels,
                    onChanged: (double val) {
                      setState(() {
                        _sliderValueTU = val;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '40°C',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_sliderValueUU.round().toString()}%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Umidade máxima',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Slider.adaptive(
                    min: 0.0,
                    max: 100.0,
                    value: _sliderValueUU,
                    divisions: 10,
                    //labels: _sliderRangeLabels,
                    onChanged: (double val) {
                      setState(() {
                        _sliderValueUU = val;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '100%',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFECB3),
                        ),
                        onPressed: _val3
                            ? null
                            : () {
                                setState(() {
                                  print("onPressed");
                                  createUmidificadorPost(
                                      temperatura: _sliderValueTU,
                                      umidade: _sliderValueUU,
                                      versao: _val3);
                                  print(_sliderValueTU);
                                  print(_sliderValueUU);
                                });
                              },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('images/umidificador.png'),
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              _energia3 == true ? 'Ligado' : 'Desligado',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
