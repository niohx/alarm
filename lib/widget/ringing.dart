import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:myalarm/widget/src/appbar.dart';
import 'package:myalarm/model/alarm.dart';

class Ringing extends StatelessWidget {
  Ringing({Key key, AlarmController alarm}) : super(key: key) {
    FlutterRingtonePlayer.playAlarm();
  }
  AlarmController alarm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar(), //MyAppBar(appBar: AppBar()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ringing',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    child: Text('StartAlarm'),
                    onPressed: () {
                      FlutterRingtonePlayer.playAlarm(volume: 10);
                    }),
                RaisedButton(
                    child: Text('Stop'),
                    onPressed: () {
                      FlutterRingtonePlayer.stop();
                      alarm.dismissAlarm();
                    }),
                RaisedButton(child: Text('snooze'), onPressed: () {})
              ],
            )
          ],
        ),
      ),
    );
  }
}
