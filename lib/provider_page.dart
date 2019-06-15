import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider 的页面显示
class ProviderPage extends StatefulWidget {
  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => ProviderModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var counter =  Provider.of<ProviderModel>(context);
              return new Text("Provider ${counter.count.toString()}");
            },
          )
        ),
        body: CountWidget(),
      ),
    );
  }
}

class CountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderModel>(builder: (context, counter, _) {
      return new Column(
        children: <Widget>[
          new Expanded(child: new Center(child: new Text(counter.count.toString()))),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  counter.add();
                },
                color: Colors.blue,
                child: new Text("+")),
          ),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  counter.dec();
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

class ProviderModel extends ChangeNotifier {
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
}
