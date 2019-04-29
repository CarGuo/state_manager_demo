import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopedPage extends StatefulWidget {
  @override
  _ScopedPageState createState() => _ScopedPageState();
}

class _ScopedPageState extends State<ScopedPage> {
  final CountModel _model = new CountModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("scoped"),
        ),
        body: Container(
          child: new ScopedModel<CountModel>(
            model: _model,
            child: CountWidget(),
          ),
        ));
  }
}

class CountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<CountModel>(
        builder: (context, child, model) {
      return new Column(
        children: <Widget>[
          new Expanded(
              child: new Center(child: new Text(model.count.toString()))),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  model.add();
                },
                color: Colors.blue,
                child: new Text("+")),
          ),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  CountModel.of(context).dec();
                },
                color: Colors.blue,
                child: new Text("-")),
          ),
          new SizedBox(
            height: 100,
          )
        ],
      );
    });
  }
}

class CountModel extends Model {
  int _count = 0;

  int get count => _count;

  void add() {
    _count++;
    notifyListeners();
  }

  void dec() {
    _count--;
    notifyListeners();
  }

  static CountModel of(BuildContext context) =>
      ScopedModel.of<CountModel>(context);
}
