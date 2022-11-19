import 'package:flutter/material.dart';
import 'package:aplicacao_unip/appalarm/data/models/menu_info.dart';
import 'package:provider/provider.dart';
import 'conteudo_despertador.dart';

class PaginaAlarme extends StatefulWidget {
  @override
  _PaginaAlarmeState createState() => _PaginaAlarmeState();
}

class _PaginaAlarmeState extends State<PaginaAlarme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 2, 19),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Consumer<MenuInfo>(
              builder: (BuildContext context, MenuInfo value, Widget? child) {
                return ConteudoDespertador();
              },
            ),
          )
        ],
      ),
    );
  }
}
