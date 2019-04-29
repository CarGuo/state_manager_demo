import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

///Fish Redux 的 count 演示
///继承 Page
class FishPage extends Page<CountState, Map<String, dynamic>> {
  FishPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          ///配置 View 显示
          view: buildView,
          ///配置 Dependencies 显示
          dependencies: Dependencies<CountState>(
              slots: <String, Dependent<CountState>>{
                ///通过 Connector() 从 大 state 转化处小 state
                ///然后将数据渲染到 Component
                'count-double': DoubleCountConnector() + DoubleCountComponent()
              }
          ),
          middleware: <Middleware<CountState>>[
            ///中间键打印log
            logMiddleware(tag: 'FishPage'),
          ]
  );
}

///渲染主页
Widget buildView(CountState state, Dispatch dispatch, ViewService viewService) {
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
class CountState implements Cloneable<CountState> {
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
Effect<CountState> buildEffect() {
  ///针对生命周期和action，可拦截和异步
  return combineEffects(<Object, Effect<CountState>>{
    Lifecycle.initState: (Action action, Context<CountState> ctx) {
      return false;
    },
    CountAction.onAdd: (Action action, Context<CountState> ctx) {
      print("********** buildEffect action onAdd ********** ");
      return false;
    },
    CountAction.onDec: (Action action, Context<CountState> ctx) {
      print("********** buildEffect action onDec ********** ");
      return false;
    },
  });
}

///Action 对象
enum CountAction { onDec, onAdd }

class CountActionCreator {
  static Action onAddAction() {
    return const Action(CountAction.onAdd);
  }

  static Action onDecAction() {
    return const Action(CountAction.onDec);
  }
}

/// Reducer 对象
Reducer<CountState> buildReducer() {
  return asReducer(
    <Object, Reducer<CountState>>{CountAction.onAdd: _addReducer, CountAction.onDec: _desReducer},
  );
}

CountState _addReducer(CountState state, Action action) {
  final CountState newState = state.clone();
  newState.count++;
  print("********** _addReducer action onAdd ********** ");
  return newState;
}

CountState _desReducer(CountState state, Action action) {
  final CountState newState = state.clone();
  newState.count--;
  print("********** _desReducer action onAdd ********** ");
  return newState;
}

/// Dependencies 的 Connector
/// 将 CountState 转化为 int
class DoubleCountConnector extends ConnOp<CountState, int> {
  @override
  int get(CountState state) {
    return state.count;
  }

  @override
  void set(CountState state, int subState) {}
}

/// Dependencies 的 Component
/// 显示独立控件
class DoubleCountComponent extends Component<int> {
  DoubleCountComponent()
      : super(
          view: (
            int state,
            Dispatch dispatch,
            ViewService viewService,
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


Middleware<T> logMiddleware<T>({
  String tag = 'redux',
  String Function(T) monitor,
}) {
  return ({Dispatch dispatch, Get<T> getState}) {
    return (Dispatch next) {
      return isDebug()
          ? (Action action) {
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

        if (prevState == nextState) {
          if (!shouldBeInterruptedBeforeReducer(action)) {
            print('[$tag] warning: ${action.type} has not been used.');
          }
        }

        print('========== [$tag] ================');
        print("\n");
        print("\n");
      }
          : next;
    };
  };
}