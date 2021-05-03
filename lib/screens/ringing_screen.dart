import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:alarm/model/alarm_model.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class RingingScreen extends HookWidget {
  final AlarmState alarm;

  RingingScreen({Key? key, required this.alarm}) {
    FlutterRingtonePlayer.playAlarm();
  }

  @override
  Widget build(BuildContext context) {
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
              ElevatedButton(
                  child: Text('Stop'),
                  onPressed: () {
                    FlutterRingtonePlayer.stop();

                    Navigator.pop(context, alarm);
                  }),
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
