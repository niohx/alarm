import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:myalarm/model/alarm.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Ringing extends HookWidget {
<<<<<<< HEAD
  final StateNotifierProvider<AlarmList> alarmProvider;
=======
  final StateNotifierProvider<AlarmController> alarmProvider;
>>>>>>> master
  Ringing({Key key, @required this.alarmProvider}) {
    FlutterRingtonePlayer.playAlarm();
  }

  @override
  Widget build(BuildContext context) {
    //print(alarmProvider.state);
    final _alarm = useProvider(alarmProvider);
    //final state = useProvider(alarm.state);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'ringing ',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                  child: Text('PlayAlarmTone'),
                  onPressed: () {
                    FlutterRingtonePlayer.playAlarm(volume: 10);
                  }),
              RaisedButton(
                  child: Text('Stop'),
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    _alarm.dismissAlarm();
                  }),
              RaisedButton(child: Text('snooze'), onPressed: () {})
            ],
          )
        ],
      ),
    );
  }
}
