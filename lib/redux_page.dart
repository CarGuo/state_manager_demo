import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ReduxPage extends StatefulWidget {
  @override
  _ReduxPageState createState() => _ReduxPageState();
}

class _ReduxPageState extends State<ReduxPage> {
  final store = new Store<CountState>(
    appReducer,
    middleware: middleware,
    initialState: new CountState(count: 0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("redux"),
        ),
        body: Container(
          child: new StoreProvider(
            store: store,
            child: CountWidget(),
          ),
        ));
  }
}

class CountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<CountState>(builder: (context, countState) {
      return new Column(
        children: <Widget>[
          new Expanded(
              child: new Center(
                  child: new Text(countState.state.count.toString()))),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  countState.dispatch(new AddCountAction());
                },
                color: Colors.blue,
                child: new Text("+")),
          ),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  countState.dispatch(DecCountAction());
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

final List<Middleware<CountState>> middleware = [
  CountMiddleware(),
];

class CountMiddleware implements MiddlewareClass<CountState> {
  @override
  void call(Store<CountState> store, dynamic action, NextDispatcher next) {
    if (action is AddCountAction) {
      print("*********** AddCountAction  Middleware*********** ");
    } else if (action is DecCountAction) {
      print("*********** DecCountAction  Middleware*********** ");
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

CountState appReducer(CountState state, action) {
  return CountState(
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    count: countReducer(state.count, action),
  );
}

final countReducer = combineReducers<int>([
  TypedReducer<int, AddCountAction>(_addHandler),
  TypedReducer<int, DecCountAction>(_decHandler),
]);

int _addHandler(int count, action) {
  count++;
  return count;
}

int _decHandler(int count, action) {
  count--;
  return count;
}

class AddCountAction {}

class DecCountAction {}

class CountState {
  int count;

  CountState({this.count});
}
