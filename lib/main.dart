import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:va_client/redux/app_state.dart';
import 'package:va_client/redux/reducer.dart';
import 'package:va_client/screens/auth_screen.dart';
import 'package:va_client/screens/home_screen.dart';
import 'package:va_client/screens/splash_screen.dart';

Future<void> main() async {
  final store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initialState(),
    middleware: [thunkMiddleware, LoggingMiddleware.printer()],
  );
  await DotEnv().load('.env');
  runApp(StoreProvider(store: store, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ассистент',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange[300],
        accentColor: Colors.orange[50],
        backgroundColor: Colors.red[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) {
          return HomeScreen();
        },
        '/auth': (context) {
          return AuthScreen();
        }
      },
    );
  }
}
