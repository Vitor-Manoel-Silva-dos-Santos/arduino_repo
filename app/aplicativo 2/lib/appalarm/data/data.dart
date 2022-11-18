import 'package:aplicacao_unip/appalarm/data/enums.dart';
import 'package:aplicacao_unip/appalarm/data/models/alarm_info.dart';
import 'package:aplicacao_unip/appalarm/data/models/menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock,
      title: 'Relógio', imageSource: 'assets/clock_icon.png'),
  MenuInfo(MenuType.alarm,
      title: 'Alarme', imageSource: 'assets/alarm_icon.png'),
];

List<AlarmInfo> alarms = [
  AlarmInfo(
      alarmDateTime: DateTime.now().add(Duration(hours: 1)),
      title: 'Office',
      gradientColorIndex: 0),
  AlarmInfo(
      alarmDateTime: DateTime.now().add(Duration(hours: 2)),
      title: 'Sport',
      gradientColorIndex: 1),
];
