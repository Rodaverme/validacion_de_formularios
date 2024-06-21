import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_de_formularios/providers/login_form_provider.dart';
import 'package:validacion_de_formularios/ui/input_decorations.dart';
import 'package:validacion_de_formularios/widgets/widgets.dart';

import '../services/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          CardContainer(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(), child: _LoginForm())
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'registro'),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(StadiumBorder()),
                overlayColor:
                    MaterialStateProperty.all(Colors.indigo.withOpacity(0.1))),
            child: const Text(
              'Crear una nueva cuenta',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginform = Provider.of<LoginFormProvider>(context);
    return Container(
      child: Form(
          key: loginform.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDescoration(
                    hintText: 'example@gmail.com',
                    labelText: 'Correo Electronico',
                    prefixIcon: Icons.alternate_email_sharp),
                onChanged: (value) => loginform.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor ingredado no luce como un correo';
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                decoration: InputDecorations.authInputDescoration(
                  hintText: '******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline,
                ),
                onChanged: (value) => loginform.passwors = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe de ser de 6  caracteres';
                },
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(
                      loginform.isLoading ? 'Espere' : 'Ingresar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: loginform.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          if (!loginform.isValidForm()) return;
                          loginform.isLoading = true;

                          final String? errorMessage = await authService.login(
                              loginform.email, loginform.passwors);

                          if (errorMessage == null) {
                            Navigator.pushReplacementNamed(context, 'Home');
                          } else {
                            // print(errorMessage);
                            NotificationsService.showSanckbar(
                                'Correo o Contraseña incorrectos');
                            loginform.isLoading = false;
                          }
                        })
            ],
          )),
    );
  }
}
