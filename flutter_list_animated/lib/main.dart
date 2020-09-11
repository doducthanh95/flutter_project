import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  List<int> _data = [1, 2, 3, 4, 5, 6, 7, 8];
  final GlobalKey<SliverAnimatedListState> _key = GlobalKey();

  void _incrementCounter() {
    _key.currentState.removeItem(
        1, (context, animation) => _buildItem(context, 1, animation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addItem,
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          SliverAnimatedList(
              initialItemCount: _data.length,
              key: _key,
              itemBuilder: (context, index, animation) =>
                  _buildItem(context, index, animation))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _buildItem(BuildContext builder, int index, Animation animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
          width: 300,
          height: 50,
          margin: EdgeInsets.all(20),
          color: Colors.green,
          child: Text(_data[index].toString())),
    );
  }

  _addItem() {
    _data.add(99);
    _key.currentState.insertItem(1);
  }
}
