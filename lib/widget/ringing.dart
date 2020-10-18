import 'package:flutter/material.dart';

class Ringing extends StatelessWidget {
  Ringing({Key key, String time}) : super(key: key);
  String time;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyAlarm',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(),
          body: RingingBody(time: this.time ?? 'oh no'),
        ));
  }

  //Routing Method
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => Ringing(),
    );
  }
}

class RingingBody extends StatelessWidget {
  RingingBody({Key key, @required time}) : super(key: key);
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('sure'),
          Row(
            children: [
              FlatButton(onPressed: () {}, child: Text('Stop')),
              FlatButton(onPressed: () {}, child: Text('Snooze'))
            ],
          )
        ],
      ),
    );
  }
}
