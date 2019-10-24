import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  final _controller = StreamController<BlocEvent>();

  @override
  Widget build(BuildContext context) {
    _controller.sink.add(LoggingOutEvent());
    return StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final event = snapshot.data;
          if (event is LoggingInEvent) {
            return MainPage();
          }
          if (event is LoggingOutEvent) {
            return SignInPage(sink: _controller.sink);
          }
        }
        return SplashPage();
      },
    );
  }

  void dispose() {
    _controller.close();
  }
}

abstract class BlocEvent {}

class LoggingInEvent extends BlocEvent {}

class LoggingOutEvent extends BlocEvent {}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Splash Screen",
        style: Theme.of(context).textTheme.display1,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  final StreamSink<BlocEvent> sink;

  const SignInPage({Key key, this.sink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.elasticInOut,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: MaterialButton(
            color: Theme.of(context).accentColor,
            minWidth: 100.0,
            height: 42.0,
            child: Text("Sign In"),
            onPressed: () => sink.add(LoggingInEvent())),
      ),
    ));
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            "Main Page",
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.center,
          ),
        ));
  }
}
