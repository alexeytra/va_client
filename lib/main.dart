import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:va_client/redux/app_state.dart';
import 'package:va_client/redux/reducer.dart';
import 'package:va_client/screens/splash_screen.dart';

void main() {
  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initialState(),
    middleware: [new LoggingMiddleware.printer()],
  );
  print('Initial state: ${store.state.visibilityInput}');

  runApp(StoreProvider(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
          title: 'Виртуальный ассистент',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.orange[300],
            accentColor: Colors.orange[50],
            backgroundColor: Colors.red[50],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen());
  }
}
