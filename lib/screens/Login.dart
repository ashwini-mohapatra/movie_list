import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }

}
class _Login extends State<Login>{


  final providers = [
    AuthUiProvider.google,
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          child: FlatButton(
            child: Text("Login"),
            onPressed: () async{
              final providers = [
                AuthUiProvider.google,
                ];
              final result = await FlutterAuthUi.startUi(
                items: providers,
                tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                  tosUrl: "https://www.google.com",
                  privacyPolicyUrl: "https://www.google.com",
                ),
                androidOption: AndroidOption(
                  enableSmartLock: false, // default true
                  showLogo: true, // default false
                  overrideTheme: true, // default false
                ),
              );
            },
          ),
        ),
    );
  }

}