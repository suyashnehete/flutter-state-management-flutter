import 'package:flutter/material.dart';
import 'package:provider/data.dart';
import 'package:provider/simpleprovider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Data(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${Provider.of<Data>(context).temp}"),
          Text("${Provider.of<Data>(context).temp}"),
          ElevatedButton(
            onPressed: () {
              Provider.of<Data>(context).increment();
            },
            child: Text("Increment"),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<Data>(context).decrement();
            },
            child: Text("Decrement"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage1()));
            },
            child: Text("Push"),
          ),
        ],
      ),
    );
  }
}

class MyHomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${Provider.of<Data>(context).temp}"),
          Text("${Provider.of<Data>(context).temp}"),
          ElevatedButton(
            onPressed: () {
              Provider.of<Data>(context).increment();
            },
            child: Text("Increment"),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<Data>(context).decrement();
            },
            child: Text("Decrement"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Pop"),
          ),
        ],
      ),
    );
  }
}
