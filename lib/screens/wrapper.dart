import 'package:dbapp/screens/authenticate/authenticate.dart';
import 'package:dbapp/screens/home/homeHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(context) {
    final user = Provider.of<User>(context);
    //either home or auth widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomeHandler();
    }
  }
}
