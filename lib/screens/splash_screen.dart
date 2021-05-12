import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:va_client/models/view_model.dart';
import 'package:va_client/redux/app_state.dart';
import 'package:va_client/services/message_service.dart';
import 'home_screen.dart';
import 'package:va_client/utils/functions.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1), // 5 потом поставить 5 секунд
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      distinct: true,
      onInit: (store) async {
        var auth = await getAuthData();
        if (auth != null) {
          print('auth >>>>>> ' + auth.login + ' ' + auth.password);
          store.dispatch(login(auth.login, auth.password));
        }
      },
      converter: (store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => Scaffold(
          backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('assets/5.gif'),
        ),
      ),
    );
  }
}
