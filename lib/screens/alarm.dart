import 'package:flutter/material.dart';
import 'package:alarm/model/alarm_model.dart';
import 'package:alarm/model/alarm_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:alarm/screens/alarm_setting.dart';
import 'package:intl/intl.dart';
import 'package:alarm/screens/ringing.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAlarm extends HookWidget {
  MyAlarm({Key key, this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    final _alarms = useProvider(alarmProvider.state);
    //アラームが来たときの処理
    return ProviderListener<List<AlarmState>>(
      provider: alarmProvider.state,
      onChange: (context, alarms) async {
        AlarmState ringingAlarm;
        try {
          ringingAlarm = alarms.firstWhere(
            (element) => element.ringing == true,
            orElse: () => null,
          );
          if (ringingAlarm != null) {
            print('fire!!!');
            final AlarmState result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Ringing(alarm: ringingAlarm),
              ),
            );
            context.read(alarmProvider).canselAlarm(result);
          }
        } catch (e) {
          print(e);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.alarm),
          title: Text('Alarm'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _showAlertDialog(context),
            )
          ],
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Card(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Text('＋ボタンを押してアラームを追加して下さい。'),
                ),
              ),
              for (var i = 0; i < _alarms.length; i++)
                Card(
                  child: ListTile(
                    leading: Icon(Icons.alarm,
                        color: _alarms[i].mount ? Colors.blue : Colors.grey),
                    title: Text("${toFormatedTime(_alarms[i].time)}"),
                    onTap: () {
                      // context
                      //     .read(alarmProvider)
                      //     .setAlarm(_alarms[i], _alarms[i].time);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingAlarm(alarm: _alarms[i]),
                        ),
                      );
                    },
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            context.read(alarmProvider).removeAlarm(_alarms[i]);
                          },
                        ),
                        Switch(
                          value: _alarms[i].mount,
                          onChanged: (value) {
                            context.read(alarmProvider).toggleAlarm(_alarms[i]);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ListTile(
                  title: Icon(Icons.add),
                  onTap: () {
                    context.read(alarmProvider).addAlarm(_alarms.length + 1);
                  }),
              OutlineButton(
                onPressed: () {
                  context.read(alarmProvider).clearAllAlarm();
                  //_alarm.reservedClearAlarm();
                },
                child: Text('全てのアラームを削除する'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String toFormatedTime(String time) {
    var formatter = DateFormat('H:mm');
    return formatter.format(DateTime.parse(time));
  }

  void _showAlertDialog(BuildContext context) async {
    DateTime _time;
    DateTime resetTime;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('resetTime')) {
      _time = DateTime.parse(prefs.getString('resetTime'));
    } else {
      _time = DateTime.now();
    }
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('リセット時間を選択して下さい'),
            content: TimePickerSpinner(
              time: _time,
              is24HourMode: true,
              spacing: 40,
              itemHeight: 40,
              isForce2Digits: true,
              onTimeChange: (time) {
                DateTime _now = DateTime.now();
                if (time.isAfter(_now)) {
                  resetTime = time;
                } else {
                  resetTime = time.add(Duration(days: 1));
                }
                ;
              },
            ),
            actions: [
              FlatButton(
                child: Text('set'),
                onPressed: () {
                  print("reset time is $resetTime");
                  context.read(alarmProvider).releaseAllAlarmsAt(resetTime);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('cansel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
