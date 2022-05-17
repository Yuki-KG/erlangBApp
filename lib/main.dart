import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ErlangBApp());
}

class ErlangBApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Erlang B Formula',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Erlang B Formula Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _traffic = 0.0;
  double _lines = 0.0;
  double _blocking = 0.0;
  String _textA = '';
  String _textL = '';
  String _esText = '';


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: new InputDecoration(labelText: "Traffic (erlangs)"),
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
              onChanged: (String value) {
                setState(() {
                  _textA = value;
                  _traffic = double.parse(_textA);
                });
              }
            ),
            TextField(
              decoration: new InputDecoration(labelText: "Number of Lines"),
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
              onChanged: (String value) {
                setState(() {
                  _textL = value;
                  _lines = double.parse(_textL);
                });
              }
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if(_lines.floor() == _lines) {
                      _blocking = ES(_traffic, _lines.toInt());
                    } else {
                      _blocking = ESCont(_traffic, _lines);
                    }
                    _esText = (_blocking == 0.0) ? '' : 'Blocking Rate = $_blocking %';
                  });
                },
                child: Text('Calculate!'),
            ),

            /*Text('$_servers servers',
              style: TextStyle(fontSize: 24),
            ),*/
            Text('$_esText',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

double ES(double a, int s) {
  int i;
  double es = 1.0;
  for(i = 1; i <= s; i++) {
    es = a * es / (i + a*es);
  }
  return(100.0 * es);
}

double ESCont(double a, double s) {
  int i;
  int n = s.toInt();
  double x = s - n.toDouble();
  int k = (5/4*sqrt(x+500) + 4/a).toInt();
  double esk = a;
  double es;

  for(i = k; i >= 1; i--) {
    esk = a + (-x + i - 1)/(1 + i/esk);
  }
  es = esk / a;

  for(i = 1; i <= n; i++) {
    es = a * es/(x + i + a*es);
  }
  return(100.0 * es);
}