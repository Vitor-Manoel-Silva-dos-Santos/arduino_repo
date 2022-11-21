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

  bool val1 = true;
  bool val2 = true;
  bool val3 = true;

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

  @override
  void initState() {
    super.initState();
    _recuperarDadosServidor();
  }

  postData({required double temperatura, required double umidade}) async {
    print("funcao postdata");
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.https('arduino-unip.herokuapp.com', '/sensores', {'q': '{http}'}),
          body: {
            'janela': {
              'aberta': 'true',
              'manual': 'false',
              'temperatura_de_ativacao': temperatura,
              'umidade_de_ativacao': 'umidade',
            },
          });
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decodedResponse['uri'] as String);
      print(await client.get(uri));
    } finally {
      client.close();
    }
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
                        child: LiteRollingSwitch(
                          value: val1,
                          textOn: "Manual",
                          textOff: "Automático",
                          colorOn: Color.fromARGB(255, 175, 23, 23),
                          colorOff: Color.fromARGB(255, 231, 123, 123),
                          iconOn: Icons.lock,
                          iconOff: Icons.lock_open_rounded,
                          textSize: 10.0,
                          width: 105,
                          onChanged: (bool state) {
                            setState(() {
                              print("botaswitch");
                              val1 = state;
                            });
                          },
                          onDoubleTap: () {},
                          onSwipe: () {},
                          onTap: () {},
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
                        onPressed: !val1
                            ? () {
                                print("onPressed");
                                postData(
                                    temperatura: _sliderValueTJ,
                                    umidade: _sliderValueUJ);
                                print(_sliderValueTJ);
                                print(_sliderValueUJ);
                              }
                            : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.window, color: Colors.black),
                            Text(
                              'Aberta',
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
                        child: LiteRollingSwitch(
                          value: val2,
                          textOn: "Manual",
                          textOff: "Automático",
                          colorOn: Color.fromARGB(255, 64, 46, 233),
                          colorOff: Color.fromARGB(255, 54, 163, 206),
                          iconOn: Icons.lock,
                          iconOff: Icons.lock_open_rounded,
                          textSize: 10.0,
                          width: 105,
                          onChanged: (bool state) {
                            setState(() {
                              val2 = state;
                            });
                          },
                          onDoubleTap: () {},
                          onSwipe: () {},
                          onTap: () {},
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
                        onPressed: !val2 ? () {} : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('images/ventilador.png'),
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              'Ligado',
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
                        child: LiteRollingSwitch(
                          value: val3,
                          textOn: "Manual",
                          textOff: "Automático",
                          colorOn: Color.fromARGB(164, 172, 172, 36),
                          colorOff: Color.fromARGB(255, 231, 228, 28),
                          iconOn: Icons.lock,
                          iconOff: Icons.lock_open_rounded,
                          textSize: 10.0,
                          width: 105,
                          onChanged: (bool state) {
                            setState(() {
                              val3 = state;
                            });
                          },
                          onDoubleTap: () {},
                          onSwipe: () {},
                          onTap: () {},
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
                        onPressed: !val3 ? () {} : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('images/umidificador.png'),
                              width: 25,
                              height: 25,
                            ),
                            Text(
                              'Ligado',
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
