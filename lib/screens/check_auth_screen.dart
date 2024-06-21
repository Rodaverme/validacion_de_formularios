import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_de_formularios/screens/screens.dart';

import '../services/services.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: authService.readToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Espere');

          if (snapshot.data == '') {
            //} ;
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginScreen(),
                      transitionDuration: Duration(seconds: 0)));

              // Navigator.of(context).pushReplacementNamed('Home');
            });
          } else {
            Future.microtask(() {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => HomeScreen(),
                      transitionDuration: Duration(seconds: 0)));

              // Navigator.of(context).pushReplacementNamed('Home');
            });
          }
          return Container();
        },
      )),
    );
  }
}
