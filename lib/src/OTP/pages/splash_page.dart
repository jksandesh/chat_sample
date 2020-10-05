import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:chat_sample/src/OTP/pages/home_page.dart';
import 'package:chat_sample/src/OTP/pages/login_page.dart';
import 'package:chat_sample/src/OTP/stores/login_store.dart';
import 'package:chat_sample/src/OTP/theme.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'dart:async';


class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Provider.of<LoginStore>(context, listen: false).isAlreadyAuthenticated().then((result) {
      if (result) {
        Timer(Duration(seconds: 5),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                        HomePage(),
                )
            )
        );
       } else {
        Timer(Duration(seconds: 5),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                        LoginPage(),
                ),
            )
        );
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child:Lottie.asset('assets/zzz.json')
    );
  }
}
