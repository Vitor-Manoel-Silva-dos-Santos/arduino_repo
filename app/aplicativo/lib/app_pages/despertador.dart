import 'package:flutter/material.dart';
import 'package:aplicacao_unip/appalarm/modules/views/homealarm.dart';
import 'package:provider/provider.dart';
import '../appalarm/modules/views/conteudo_despertador.dart';
import '/appalarm/data/models/menu_info.dart';
import '/appalarm/data/enums.dart';

class Despertador extends StatefulWidget {
  const Despertador({super.key});

  @override
  State<Despertador> createState() => _DespertadorState();
}

class _DespertadorState extends State<Despertador> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuInfo>(
      create: (context) => MenuInfo(MenuType.clock),
      //child: HomeAlarm(),
      child: ConteudoDespertador(),
    );
  }
}
