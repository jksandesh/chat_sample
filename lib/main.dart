import 'package:chat_sample/src/OTP/pages/splash_page.dart';
import 'package:chat_sample/src/OTP/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'dart:async';
import 'src/login_screen.dart';
import 'src/login_screen.dart';
import 'src/Call/configs.dart' as config;
import 'package:lottie/lottie.dart';
import 'package:chat_sample/src/Auth/screens/onboarding/onboarding_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: App(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

/*
class _AppState extends State<App> {
  void initState() {
    super.initState();
    init(
      config.APP_ID,
      config.AUTH_KEY,
      config.AUTH_SECRET,
    );
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    OnBoardingPage(),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child:Lottie.asset('assets/zzz.json')
    );
  }

}
*/


class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        )
      ],
      child: const MaterialApp(
        home: SplashPage(),
      ),
    );
  }
}