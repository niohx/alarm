import 'package:flutter/material.dart';
import 'package:myalarm/model/alarm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myalarm/widget/alarm_setting.dart';
import 'package:intl/intl.dart';
import 'package:myalarm/widget/src/appbar.dart';
import 'package:myalarm/widget/ringing.dart';

import 'dart:isolate';

final alarmListProvider =
    StateNotifierProvider<AlarmList>((ref) => AlarmList());

final alarms = Provider((ref) {
  final alarms = ref.watch(alarmListProvider.state);
  return alarms;
});

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
    final _alarms = useProvider(alarms);
    //_alarm.checkAlarm();
    return Scaffold(
      appBar: myappbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < _alarms.length; i++)
              Card(
                  child: ListTile(
                      leading: Icon(Icons.alarm,
                          color: _alarms[i].mount ? Colors.blue : Colors.grey),
                      title: Text("${toFormatedTime(_alarms[i].time)}"),
                      onTap: () {
                        context
                            .read(alarmListProvider)
                            .setAlarm(_alarms[i], _alarms[i].time);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlarmRoot(
                                    alarms: _alarms, id: _alarms[i].id)));
                      },
                      trailing: Wrap(children: [
                        IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              context
                                  .read(alarmListProvider)
                                  .removeAlarm(_alarms[i]);
                            }),
                        Switch(
                            value: _alarms[i].mount,
                            onChanged: (value) {
                              context
                                  .read(alarmListProvider)
                                  .toggleAlarm(_alarms[i]);
                            }),
                      ]))),
            ListTile(
                title: Icon(Icons.add),
                onTap: () {
                  context.read(alarmListProvider).addAlarm(_alarms.length);
                }),
            RaisedButton(
              onPressed: () {},
              child: Text('please set the alarm'),
            ),
            RaisedButton(
              onPressed: () {
                //_alarm.reservedClearAlarm();
              },
              child: Text('clear all alarm'),
            ),
            RaisedButton(
              onPressed: () {},
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
