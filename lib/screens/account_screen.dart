import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:va_client/models/view_model.dart';
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
              CircleAvatar(),
              Text(viewModel.loginResponse.getName()),
              TextButton(
                  onPressed: () {
                    clearAuthData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    viewModel.logout();
                  },
                  child: Text('Выйти'))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('dispose >>>>>>>>>>>>>');
    super.dispose();
  }
}

