import 'package:flutter/material.dart';
import 'package:myalarm/model/alarm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myalarm/widget/alarm_setting.dart';
import 'package:intl/intl.dart';
import 'package:myalarm/widget/src/appbar.dart';
import 'package:myalarm/widget/ringing.dart';

import 'dart:isolate';

final alarmProvider =
    StateNotifierProvider<AlarmController>((ref) => AlarmController());

class MyAlarm extends HookWidget {
  MyAlarm({Key key, this.title}) : super(key: key);
  // static Route<dynamic> route() {
  //   return MaterialPageRoute(
  //     builder: (context) => MyAlarm(),
  //   );
  // }
  final String title;
  @override
  Widget build(BuildContext context) {
    final _alarm = useProvider(alarmProvider);
    //final state = useProvider(alarmProvider.state);
    //_alarm.checkAlarm();
    return (_alarm.state.ringing)
        ? Ringing(alarm: _alarm)
        : Scaffold(
            appBar: myappbar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                      child: ListTile(
                    leading: Icon(Icons.alarm,
                        color: _alarm.state.mount ? Colors.blue : Colors.grey),
                    title: Text("${toFormatedTime(_alarm.state.time)}"),
                    onTap: () {
                      _alarm.setAlarm(_alarm.state.time);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlarmRoot(alarm: _alarm)));
                    },
                    trailing: Switch(
                        value: _alarm.state.mount,
                        onChanged: (value) {
                          print(value);
                          _alarm.toggleAlarm(value); //value, state.time);
                        }),
                  )),
                  ListTile(title: Icon(Icons.add), onTap: () {}),
                  RaisedButton(
                    onPressed: () {
                      _alarm.setAlarm(_alarm.state.time);
                    },
                    child: Text('please set the alarm'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _alarm.reservedClearAlarm();
                    },
                    child: Text('clear all alarm'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      print('${_alarm.state.used}');
                      print(_alarm.state.mount);
                    },
                    child: Text('function check'),
                  )
                ],
              ),
            ),
          );
  }

  String toFormatedTime(String time) {
    var formatter = DateFormat('H:mm');
    return formatter.format(DateTime.parse(time));
  }

  void printHello() {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  }
}
