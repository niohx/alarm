import 'package:flutter/material.dart';

class Ringing extends StatelessWidget {
  Ringing({@required String time}) : super();
  String time;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RingingBody(time: this.time),
    );
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
          Text('{$this.time}'),
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
