import 'package:flutter/material.dart';

import 'package:dblib/dblib.dart';
import 'list_by_query_page.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dbLib Transaction test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _db = DbLib();

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  void dispose() {
    super.dispose();
    _db.disconnect();
  }

  Future<void> _connect() async {
    _db.url = Constants.SERVER_URL;
    _db.verbose = true;
    var rc = await _db.connect();
    print("connect $rc");
  }

  Future<void> _execute() async {
    var rc = await _db.execute("insert into emp (empno,ename) values (9996,'zames')");
    print('exec rc = $rc');
  }

  Future<void> _beginTrans() async {
    var rc = await _db.beginTrans();
    print('begin trans rc=$rc');
  }

  Future<void> _rollback() async {
    var rc = await _db.rollbackTrans();
    print('rollback rc=$rc');
  }

  Future<void> _commit() async {
    var rc = await _db.commitTrans();
    print('commit trans rc=$rc');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  _beginTrans();
                },
                child: Text("begin trans test")),
            ElevatedButton(
                onPressed: () async {
                  _execute();
                },
                child: Text("Execute test")),
            ElevatedButton(
                onPressed: () async {
                  _rollback();
                },
                child: Text("Rollback test")),
            ElevatedButton(
                onPressed: () async {
                  _commit();
                },
                child: Text("Commit test")),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListByQueryPage(),
                    ),
                  );
                },
                child: Text("list")),
          ],
        ),
      ),
    );
  }
}
