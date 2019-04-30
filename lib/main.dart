import 'package:flutter/material.dart';
import 'package:state_manager_demo/bloc_page.dart';
import 'package:state_manager_demo/redux_page.dart';
import 'package:state_manager_demo/scoped_page.dart';

import 'fish_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter State Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter State Manager'),
      routes: {
        "bloc": (context) {
          return BlocPage();
        },
        "scoped": (context) {
          return ScopedPage();
        },
        "redux": (context) {
          return ReduxPage();
        },
        "fish": (context) {
          return FishPage().buildPage(null);
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("bloc");
                },
                child: new Text("bloc")),
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("scoped");
                },
                child: new Text("scoped_model")),
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("redux");
                },
                child: new Text("flutter_redux")),
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("fish");
                },
                child: new Text("fish_redux")),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
