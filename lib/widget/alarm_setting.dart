import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myalarm/model/alarm.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

// final alarmProvider =
//     StateNotifierProvider<AlarmController>((ref) => AlarmController());

class AlarmRoot extends HookWidget {
  final AlarmController alarm;
  AlarmRoot({Key key, @required this.alarm}) : super(key: key);

  Widget build(BuildContext context) {
    DateTime _time;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text('${alarm.state.mount}'),
          TimePickerSpinner(
            time: DateTime.parse(alarm.state.time),
            is24HourMode: true,
            spacing: 40,
            itemHeight: 80,
            isForce2Digits: false,
            onTimeChange: (time) {
              _time = time;
            },
          ),
          RaisedButton(
            onPressed: () {
              alarm.setAlarm(_time.toIso8601String());
              Navigator.pop(context);
            },
            child: Text('set'),
            color: Colors.blue,
          )
        ],
      )),
    );
  }

  //Routing Method
  // static Route<dynamic> route() {
  //   return MaterialPageRoute(
  //     builder: (context) => AlarmRoot(state: ,),
  //   );
  // }
}
