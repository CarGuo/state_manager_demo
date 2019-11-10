import 'package:fish_redux/fish_redux.dart' as Fish;
import 'package:flutter/material.dart';

///Fish Redux 的 count 演示
///继承 Page
class FishPage extends Fish.Page<CountState, Map<String, dynamic>> {
  FishPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          ///配置 View 显示
          view: buildView,
          ///配置 Dependencies 显示
          dependencies: Fish.Dependencies<CountState>(
              slots: <String, Fish.Dependent<CountState>>{
                ///通过 Connector() 从 大 state 转化处小 state
                ///然后将数据渲染到 Component
                'count-double': DoubleCountConnector() + DoubleCountComponent()
              }
          ),
          middleware: <Fish.Middleware<CountState>>[
            ///中间键打印log
            logMiddleware(tag: 'FishPage'),
          ]
  );
}

///渲染主页
Widget buildView(CountState state, Fish.Dispatch dispatch, Fish.ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
        title: new Text("fish"),
      ),
      body: new Column(
        children: <Widget>[
          ///viewService 渲染 dependencies
          viewService.buildComponent('count-double'),
          new Expanded(child: new Center(child: new Text(state.count.toString()))),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  ///+
                  dispatch(CountActionCreator.onAddAction());
                },
                color: Colors.blue,
                child: new Text("+")),
          ),
          new Center(
            child: new FlatButton(
                onPressed: () {
                  ///-
                  dispatch(CountActionCreator.onDecAction());
                },
                color: Colors.blue,
                child: new Text("-")),
          ),
          new SizedBox(
            height: 100,
          )
        ],
      ));
}

/// state 对象
class CountState implements Fish.Cloneable<CountState> {
  int count = 0;

  @override
  CountState clone() {
    return CountState()..count = count;
  }
}

/// 初始化对象
CountState initState(Map<String, dynamic> args) {
  //just demo, do nothing here...
  return CountState();
}

/// 副作用处理
Fish.Effect<CountState> buildEffect() {
  ///针对生命周期和action，可拦截和异步
  return Fish.combineEffects(<Object, Fish.Effect<CountState>>{
    Fish.Lifecycle.initState: (action, Fish.Context<CountState> ctx) {
      return false;
    },
    CountAction.onAdd: (action, Fish.Context<CountState> ctx) {
      print("********** buildEffect action onAdd ********** ");
      return false;
    },
    CountAction.onDec: (action, Fish.Context<CountState> ctx) {
      print("********** buildEffect action onDec ********** ");
      return false;
    },
  });
}

///Action 对象
enum CountAction { onDec, onAdd }

class CountActionCreator {
  static Fish.Action onAddAction() {
    return const Fish.Action(CountAction.onAdd);
  }

  static Fish.Action onDecAction() {
    return const Fish.Action(CountAction.onDec);
  }
}

/// Reducer 对象
Fish.Reducer<CountState> buildReducer() {
  return Fish.asReducer(
    <Object, Fish.Reducer<CountState>>{CountAction.onAdd: _addReducer, CountAction.onDec: _desReducer},
  );
}

CountState _addReducer(CountState state, Fish.Action action) {
  final CountState newState = state.clone();
  newState.count++;
  print("********** _addReducer action onAdd ********** ");
  return newState;
}

CountState _desReducer(CountState state, Fish.Action action) {
  final CountState newState = state.clone();
  newState.count--;
  print("********** _desReducer action onAdd ********** ");
  return newState;
}

/// Dependencies 的 Connector
/// 将 CountState 转化为 int
class DoubleCountConnector extends Fish.ConnOp<CountState, int> {
  @override
  int get(CountState state) {
    return state.count;
  }

  @override
  void set(CountState state, int subState) {}
}

/// Dependencies 的 Component
/// 显示独立控件
class DoubleCountComponent extends Fish.Component<int> {
  DoubleCountComponent()
      : super(
          view: (
            int state,
              Fish.Dispatch dispatch,
              Fish.ViewService viewService,
          ) {
            return new Container(margin: EdgeInsets.all(50),
                child: new Center(
                    child: new Text((state * 2).toString()
                    ),
                ),
            );
          },
        );
}


Fish.Middleware<T> logMiddleware<T>({
  String tag = 'redux',
  String Function(T) monitor,
}) {
  return ({Fish.Dispatch dispatch, Fish.Get<T> getState}) {
    return (Fish.Dispatch next) {
      return Fish.isDebug()
          ? (Fish.Action action) {
        print("\n");
        print("\n");
        print('---------- [$tag] ----------');
        print('[$tag] ${action.type} ${action.payload}');

        final T prevState = getState();
        if (monitor != null) {
          print('[$tag] prev-state: ${monitor(prevState)}');
        }

        next(action);

        final T nextState = getState();
        if (monitor != null) {
          print('[$tag] next-state: ${monitor(nextState)}');
        }

        /*if (prevState == nextState) {
          if (!Fish.shouldBeInterruptedBeforeReducer(action)) {
            print('[$tag] warning: ${action.type} has not been used.');
          }
        }*/

        print('========== [$tag] ================');
        print("\n");
        print("\n");
      }
          : next;
    };
  };
}