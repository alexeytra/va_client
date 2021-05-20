import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:va_client/models/navigation.dart';
import 'package:va_client/models/view_model.dart';
import 'package:va_client/redux/actions.dart';
import 'package:va_client/redux/app_state.dart';
import 'package:va_client/utils/functions.dart';

import 'home_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      distinct: true,
      onDispose: (store) {
        if (!store.state.isLogin) {
          store.dispatch(getLogoutGoodbyeAction());
        }
      },
      converter: (store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('Аккаунт',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: [
              CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.green,
                  child: Text(
                      viewModel.loginResponse != null
                          ? viewModel.loginResponse.getInitials()
                          : '',
                      style: TextStyle(
                          fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.white))),
              SizedBox(height: 70.0),
              Text(viewModel.loginResponse != null
                  ? viewModel.loginResponse.getName()
                  : '', style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center,),
              SizedBox(height: 70.0),
              TextButton(
                  onPressed: () {
                    _showUserLogoutConfirm(viewModel);
                  },
                  child: Text('Выйти', style: TextStyle(fontSize: 20.0),))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showUserLogoutConfirm(ViewModel viewModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Выход из учетной записи'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Вы действительно хотите выйти из учетной записи?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Да'),
              onPressed: () {
                clearAuthData();
                Keys.navKey.currentState.popUntil((route) => route.isFirst);
                viewModel.logout();
              },
            ),
            TextButton(
              child: Text('Нет'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
