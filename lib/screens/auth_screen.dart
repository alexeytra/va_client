import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:va_client/models/view_model.dart';
import 'package:va_client/redux/app_state.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    loginController.text = 's81834';
    passwordController.text = '28rjHELLO';
    return StoreConnector<AppState, ViewModel>(
      distinct: true,
      converter: (store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Авторизация',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: [
              Image.asset(
                'assets/newlogo.png',
                width: 160,
                height: 160,
              ),
              SizedBox(height: 48.0),
              TextFormField(
                controller: loginController,
                keyboardType: TextInputType.name,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Логин',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: passwordController,
                autofocus: true,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Пароль',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(32.0),
                  clipBehavior: Clip.antiAlias,
                  shadowColor: Colors.orangeAccent.shade100,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () async {
                      viewModel.login(loginController.text,
                          passwordController.text, context);
                    },
                    color: Colors.blueGrey,
                    child: Text(
                      'Войти',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'Авторизация необходима, если вы хотите использовать все возможности Виртуального ассистента',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
