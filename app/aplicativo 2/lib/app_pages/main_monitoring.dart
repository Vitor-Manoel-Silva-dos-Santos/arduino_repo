import 'package:responsive_framework/responsive_framework.dart';
import 'package:aplicacao_unip/resources/pages_ButtonFirstRow.dart';
import 'package:aplicacao_unip/resources/pages_ButtonSecondRow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeMonitoring extends StatefulWidget {
  const HomeMonitoring({Key? key}) : super(key: key);

  @override
  State<HomeMonitoring> createState() => _HomeMonitoringState();
}

class _HomeMonitoringState extends State<HomeMonitoring> {
  int wifi = 0;
  _recuperarDadosServidor() async {
    print("texto test wifi");
    var url =
        Uri.https('arduino-unip.herokuapp.com', '/sensores', {'q': '{http}'});
    http.Response respostaSensores;
    respostaSensores = await http.get(url);
    print("status = ${respostaSensores.statusCode}");
    if (respostaSensores.statusCode == 200) {
      setState(() {
        wifi = 1;
      });
      print("Resposta do servidor bem sucedida!");
    } else {
      print(
          "Resposta ruim do servidor com código: ${respostaSensores.statusCode}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosServidor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 1, 2, 19),
              Color.fromARGB(255, 3, 3, 39),
            ])),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 1, 2, 19),
                Color.fromARGB(255, 3, 3, 39),
              ])),
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ResponsiveWrapper(
                  minWidth: 500,
                  maxWidthLandscape: 1080,
                  breakpoints: const [
                    ResponsiveBreakpoint.autoScale(700, name: MOBILE),
                    ResponsiveBreakpoint.autoScale(1600, name: DESKTOP)
                  ],
                  child: Column(children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Smart",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blue[400]),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: const Text(
                                "Room",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Página",
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.white),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          bottom: BorderSide(
                                              color: Colors.blue, width: 3),
                                        )),
                                        child: Text(
                                          "Inicial",
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.blue[400]),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  wifi == 1 ? Icons.wifi : Icons.wifi_off,
                                  color: Colors.white,
                                )
                              ])
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        pagesButtonsFistRow(),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 10),
                          child: Pages_ButtonSecondRow(),
                        )
                      ],
                    ),
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
