import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:myalarm/model/alarm.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class Ringing extends HookWidget {
  final AlarmState alarm;

  Ringing({Key key, @required this.alarm}) {
    FlutterRingtonePlayer.playAlarm();
  }

  @override
  Widget build(BuildContext context) {
    if (alarm.ringing == false) {
      Navigator.pop(context, alarm);
      return null;
    } else {
      return Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${toFormatedTime(alarm.time)}',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // RaisedButton(
                //     child: Text('PlayAlarmTone'),
                //     onPressed: () {
                //       FlutterRingtonePlayer.playAlarm(volume: 10);
                //     }),
                RaisedButton(
                    child: Text('Stop'),
                    onPressed: () {
                      FlutterRingtonePlayer.stop();

                      Navigator.pop(context, alarm);
                      //_alarm.releaseAlarm(_alarm);
                    }),
                //RaisedButton(child: Text('snooze'), onPressed: () {})
              ],
            )
          ],
        ),
      ));
    }
  }

  String toFormatedTime(String time) {
    var formatter = DateFormat('H:mm');
    return formatter.format(DateTime.parse(time));
  }
}
